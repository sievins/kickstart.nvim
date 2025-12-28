return {
  'lukas-reineke/indent-blankline.nvim',

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
    scope = { show_start = false, show_end = false },
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
}
