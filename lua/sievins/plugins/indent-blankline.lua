return {
  {
    'lukas-reineke/indent-blankline.nvim',

    enabled = true,

    dependencies = { 'nvim-treesitter/nvim-treesitter' },

    event = { 'BufReadPre', 'BufNewFile' },

    main = 'ibl',

    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = {
        char = '┊',
        tab_char = '┊',
      },
      scope = { enabled = false }, -- mini.indentscope handles scope highlighting
      exclude = {
        filetypes = {
          'Trouble',
          'alpha',
          'dashboard',
          'help',
          'lazy',
          'mason',
          'neo-tree',
          'notify',
          'snacks_dashboard',
          'snacks_notif',
          'snacks_terminal',
          'snacks_win',
          'toggleterm',
          'trouble',
        },
      },
    },

    config = function(_, opts)
      local hooks = require 'ibl.hooks'

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- colors from theme
        vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#143652' }) -- bg_highlight - subtle indent guides
        vim.api.nvim_set_hl(0, 'IblScope', { fg = '#627E97' }) -- fg_gutter - visible scope highlight
      end)

      require('ibl').setup(opts)
    end,
  },

  {
    'nvim-mini/mini.indentscope',

    enabled = true,

    event = { 'BufReadPre', 'BufNewFile' },

    version = '*',

    opts = {
      draw = {
        -- Delay (in ms) between event and start of drawing scope indicator
        delay = 0,

        -- Disable animation
        animation = require('mini.indentscope').gen_animation.none(),

        -- Whether to auto draw scope: return `true` to draw, `false` otherwise.
        -- Default draws only fully computed scope (see `options.n_lines`).
        predicate = function(scope)
          return not scope.body.is_incomplete
        end,

        -- Symbol priority. Increase to display on top of more symbols.
        priority = 2,
      },

      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Textobjects
        object_scope = 'ii',
        object_scope_with_border = 'ai',

        -- Motions (jump to respective border line; if not present - body line)
        goto_top = '[i',
        goto_bottom = ']i',
      },

      -- Options which control scope computation
      options = {
        -- Type of scope's border: which line(s) with smaller indent to
        -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
        border = 'both',

        -- Whether to use cursor column when computing reference indent.
        -- Useful to see incremental scopes with horizontal cursor movements.
        indent_at_cursor = true,

        -- Maximum number of lines above or below within which scope is computed
        n_lines = 10000,

        -- Whether to first check input line to be a border of adjacent scope.
        -- Use it if you want to place cursor on function header to get scope of
        -- its body.
        try_as_border = true,
      },

      -- Which character to use for drawing scope indicator
      symbol = '┊',
    },

    config = function(_, opts)
      require('mini.indentscope').setup(opts)

      -- Disable in floating windows (e.g. hover popups)
      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          vim.b.miniindentscope_disable = vim.api.nvim_win_get_config(0).relative ~= ''
        end,
      })
    end,
  },
}
