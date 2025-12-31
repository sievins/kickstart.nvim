-- Neo-tree is a plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

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
          require('neo-tree.command').execute { toggle = true, dir = sievins.root() }
        end,
        desc = 'Explorer (Root Dir)',
      },
      {
        '<leader>fE',
        function()
          require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
        end,
        desc = 'Explorer (cwd)',
      },
      {
        '<leader>fr',
        function()
          require('neo-tree.command').execute { toggle = true, reveal = true }
        end,
        desc = 'Explorer (reveal)',
      },
      { '<leader>e', '<leader>fr', desc = 'Explorer', remap = true },
      {
        '<leader>ge',
        function()
          require('neo-tree.command').execute { source = 'git_status', toggle = true }
        end,
        desc = 'Git Explorer',
      },
      {
        '<leader>be',
        function()
          require('neo-tree.command').execute { source = 'buffers', toggle = true }
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
      },
      window = {
        position = 'right',
        mappings = {
          ['<space>'] = 'none',
          ['H'] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            local name = vim.fn.fnamemodify(path, ':t')
            local is_hidden = name:sub(1, 1) == '.'

            require('neo-tree.sources.filesystem.commands').toggle_hidden(state)

            -- Don't navigate back if we just hid hidden files and the current file is hidden
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
          -- ['O'] = {
          --   function(state)
          --     require('lazy.util').open(state.tree:get_node().path, { system = true })
          --   end,
          --   desc = 'Open with System Application',
          -- },
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
      -- TODO: Uncomment when Snacks.nvim is installed to update LSP references on file move/rename
      -- local function on_move(data)
      --   Snacks.rename.on_rename_file(data.source, data.destination)
      -- end
      -- local events = require 'neo-tree.events'
      -- opts.event_handlers = opts.event_handlers or {}
      -- vim.list_extend(opts.event_handlers, {
      --   { event = events.FILE_MOVED, handler = on_move },
      --   { event = events.FILE_RENAMED, handler = on_move },
      -- })

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
