-- Neo-tree is a plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

--- Find neo-tree window if open
---@return integer|nil window id or nil if not found
local function find_neo_tree_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    local source = vim.b[buf].neo_tree_source
    -- Check filetype or buffer variable set by neo-tree
    if ft == 'neo-tree' or source then
      return win
    end
  end
  return nil
end

--- Execute neo-tree command, using float position when zen mode is active
---@param opts table
local function neo_tree_execute(opts)
  local in_zen = not not (Snacks and Snacks.zen and Snacks.zen.win and Snacks.zen.win:valid())
  local desired_position = in_zen and 'float' or 'right'

  local neo_tree_win = find_neo_tree_window()

  if neo_tree_win then
    local win_config = vim.api.nvim_win_get_config(neo_tree_win)
    local currently_float = win_config.relative ~= ''

    if currently_float ~= in_zen then
      -- Position mismatch - close and reopen with correct position
      require('neo-tree.command').execute { action = 'close' }
      vim.schedule(function()
        opts.position = desired_position
        opts.toggle = nil
        if in_zen then
          opts.reveal_file = vim.fn.expand '%:p'
          opts.reveal_force_cwd = true
        end
        require('neo-tree.command').execute(opts)
      end)
    else
      -- Position matches - just close the window directly
      pcall(vim.api.nvim_win_close, neo_tree_win, true)
    end
  else
    -- Neo-tree is closed, open with correct position
    opts.position = desired_position
    if in_zen then
      opts.reveal_file = vim.fn.expand '%:p'
      opts.reveal_force_cwd = true
    end
    require('neo-tree.command').execute(opts)
  end
end

return {
  {
    'nvim-neo-tree/neo-tree.nvim',

    branch = 'v3.x',

    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- optional, but recommended
      'MunifTanjim/nui.nvim',
    },

    lazy = false, -- neo-tree will lazily load itself

    keys = {
      {
        '<leader>fe',
        function()
          neo_tree_execute { toggle = true, dir = sievins.root() }
        end,
        desc = 'Explorer (Root Dir)',
      },
      {
        '<leader>fE',
        function()
          neo_tree_execute { toggle = true, dir = vim.uv.cwd() }
        end,
        desc = 'Explorer (cwd)',
      },
      {
        '<leader>fr',
        function()
          neo_tree_execute { toggle = true, reveal = true }
        end,
        desc = 'Explorer (reveal)',
      },
      { '<leader>e', '<leader>fr', desc = 'Explorer', remap = true },
      {
        '<leader>ge',
        function()
          neo_tree_execute { source = 'git_status', toggle = true }
        end,
        desc = 'Git Explorer',
      },
      {
        '<leader>be',
        function()
          neo_tree_execute { source = 'buffers', toggle = true }
        end,
        desc = 'Buffer Explorer',
      },
    },

    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
      close_if_last_window = true,
      popup_border_style = 'single',
      -- Prevent cursor flicker by making operations synchronous
      -- git_status_async = false,
      ---@param a {type: string, path: string}
      ---@param b {type: string, path: string}
      sort_function = function(a, b)
        if a.type == b.type then
          return a.path < b.path
        else
          return a.type > b.type
        end
      end, -- Put directories underneath files
      default_component_configs = {
        git_status = {
          symbols = {
            unstaged = '󰄱',
            staged = '󰱒',
          },
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true, leave_dirs_open = true },
        use_libuv_file_watcher = true,
        -- Sync directory scan to prevent cursor flicker on open
        -- async_directory_scan = 'never',
        -- Hide file_size and last_modified columns
        components = {
          file_size = function()
            return {}
          end,
          last_modified = function()
            return {}
          end,
        },
      },
      window = {
        position = 'right',
        popup = {
          size = {
            width = 50,
            height = '80%',
          },
        },
        mappings = {
          ['<space>'] = 'none',
          ---@param state neotree.sources.filesystem.State
          ['H'] = function(state)
            ---@diagnostic disable-next-line: undefined-field
            local node = state.tree:get_node()
            local path = node:get_id()
            local name = vim.fn.fnamemodify(path, ':t')
            local is_hidden = name:sub(1, 1) == '.'

            require('neo-tree.sources.filesystem.commands').toggle_hidden(state)

            -- Don't navigate back if we just hid hidden files and the current file is hidden
            ---@diagnostic disable-next-line: undefined-field
            local now_hiding = not state.filtered_items.show_hidden
            if not (now_hiding and is_hidden) then
              require('neo-tree.sources.filesystem').navigate(state, state.path, path)
            end
          end,
          ['<C-d>'] = { 'scroll_preview', config = { direction = -10 } },
          ['<C-u>'] = { 'scroll_preview', config = { direction = 10 } },
          ['w'] = 'focus_preview',
          ['|'] = 'open_vsplit',
          ['-'] = 'open_split',
          ['W'] = 'toggle_auto_expand_width',
          ---@param state table
          ['Y'] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg('+', path, 'c')
          end,
          ['O'] = {
            ---@param state neotree.sources.filesystem.State
            ---@diagnostic disable-next-line: assign-type-mismatch
            function(state)
              ---@diagnostic disable-next-line: undefined-field
              local path = state.tree:get_node().path
              vim.ui.open(path)
            end,
            desc = 'Open with System Application',
          },
        },
      },
      event_handlers = {
        {
          event = 'neo_tree_buffer_enter',
          handler = function()
            vim.opt_local.number = true
            vim.opt_local.relativenumber = true
          end,
        },
      },
    },

    config = function(_, opts)
      require('neo-tree').setup(opts)

      -- Make neo-tree background match the rest of Neovim
      vim.api.nvim_set_hl(0, 'NeoTreeNormal', { link = 'Normal' })
      vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { link = 'Normal' })
      vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { link = 'Normal' })

      -- Refresh neo-tree git status when lazygit closes
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })

      -- Update LSP references on file move/rename
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end
      local events = require 'neo-tree.events'
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
    end,
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim', -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
  {
    's1n7ax/nvim-window-picker',
    version = '2.*',
    config = function()
      require('window-picker').setup {
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal', 'quickfix' },
          },
        },
      }
    end,
  },
}
