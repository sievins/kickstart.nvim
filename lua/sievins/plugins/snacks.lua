return {
  'folke/snacks.nvim',

  priority = 1000,

  lazy = false,

  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true }, -- disable treesitter/LSP niceties on huge files
    quickfile = { enabled = true }, -- render file before plugins load on fast open
    input = {}, -- styled vim.ui.input (LSP rename, prompts)
    image = {}, -- inline images in markdown (kitty graphics protocol)
    picker = {
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            ['<C-]>'] = { 'history_forward', mode = { 'i', 'n' } },
            ['<C-[>'] = { 'history_back', mode = { 'i', 'n' } },
            ['<C-Up>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            ['<C-Down>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            ['<C-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            ['<C-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            ['<C-|>'] = { 'edit_vsplit', mode = { 'i', 'n' } }, -- For glove80
            ['<C-\\>'] = { 'edit_vsplit', mode = { 'i', 'n' } }, -- For querty
            ['<C-->'] = { 'edit_split', mode = { 'i', 'n' } },
          },
        },
      },
    },
    zen = {
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = false,
      },
      show = {
        statusline = true,
      },
    },
    scratch = {},
  },

  config = function(_, opts)
    require('snacks').setup(opts)

    -- Initial diagnostic display state: no inline text or lines
    vim.diagnostic.config { virtual_text = false, virtual_lines = false }

    Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
    Snacks.toggle.inlay_hints():map '<leader>th'

    -- Autoformat on save (conform.lua reads vim.g.disable_autoformat)
    Snacks.toggle
      .new({
        id = 'autoformat',
        name = 'Autoformat',
        get = function()
          return not vim.g.disable_autoformat
        end,
        set = function(state)
          vim.g.disable_autoformat = not state
        end,
      })
      :map '<leader>tf'

    -- Diagnostic virtual lines and virtual text are mutually exclusive
    Snacks.toggle
      .new({
        id = 'diag_lines',
        name = 'Diagnostic virtual lines',
        get = function()
          return vim.diagnostic.config().virtual_lines ~= false
        end,
        set = function(state)
          -- Change `current_line` to false to show for all lines
          vim.diagnostic.config { virtual_lines = state and { current_line = true } or false, virtual_text = false }
        end,
      })
      :map '<leader>tl'

    Snacks.toggle
      .new({
        id = 'diag_text',
        name = 'Diagnostic virtual text',
        get = function()
          return vim.diagnostic.config().virtual_text ~= false
        end,
        set = function(state)
          vim.diagnostic.config { virtual_text = state, virtual_lines = false }
        end,
      })
      :map '<leader>ti'
  end,

  keys = {
    -- Top Pickers & Explorer
    {
      '<leader><space>',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>,',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    -- find
    {
      '<leader>ff',
      function()
        Snacks.picker.files()
      end,
      desc = 'Find Files',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Recent',
    },
    -- git
    {
      '<leader>gb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = 'Git Branches',
    },
    {
      '<leader>gll',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    {
      '<leader>glL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git Log Line',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>gS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = 'Git Stash',
    },
    {
      '<leader>glf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git Log File',
    },
    {
      '<leader>goo',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse (open)',
      mode = { 'n', 'x' },
    },
    {
      '<leader>goy',
      function()
        Snacks.gitbrowse {
          open = function(url)
            vim.fn.setreg('+', url)
          end,
          notify = false,
        }
      end,
      desc = 'GiHi. t Browse (copy)',
      mode = { 'n', 'x' },
    },
    -- gh
    {
      '<leader>goi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>goI',
      function()
        Snacks.picker.gh_issue { state = 'all' }
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>gop',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>goP',
      function()
        Snacks.picker.gh_pr { state = 'all' }
      end,
      desc = 'GitHub Pull Requests (all)',
    },
    -- Grep
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>sB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Grep Open Buffers',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    -- search
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = 'Registers',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.search_history()
      end,
      desc = 'Search History',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    {
      '<leader>sD',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = 'Buffer Diagnostics',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Pages',
    },
    {
      '<leader>sH',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'Highlights',
    },
    {
      '<leader>si',
      function()
        Snacks.picker.icons()
      end,
      desc = 'Icons',
    },
    {
      '<leader>sj',
      function()
        Snacks.picker.jumps()
      end,
      desc = 'Jumps',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Keymaps',
    },
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist()
      end,
      desc = 'Location List',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Marks',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
    {
      '<leader>sR',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    -- LSP
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'gD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = 'Goto Declaration',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'gI',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'gy',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto T[y]pe Definition',
    },
    {
      'gai',
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = 'Calls [I]ncoming',
    },
    {
      'gao',
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = 'Calls [O]utgoing',
    },

    -- Zen
    {
      '<leader>z',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle Zen Mode',
    },

    -- Terminal
    {
      '<c-/>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
      mode = { 'n', 't' },
    },
    {
      '<c-_>', -- what many terminals actually send for ctrl+slash
      function()
        Snacks.terminal()
      end,
      desc = 'which_key_ignore',
      mode = { 'n', 't' },
    },

    -- Scratch
    {
      '<leader>.',
      function()
        Snacks.scratch {
          ft = 'markdown',
        }
      end,
      desc = 'Toggle Scratch Buffer (markdown)',
    },
    {
      '<leader>:',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer (use current filetype)',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
  },
}
