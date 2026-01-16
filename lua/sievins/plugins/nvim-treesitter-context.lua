return {
  'nvim-treesitter/nvim-treesitter-context',

  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },

  opts = { mode = 'cursor', max_lines = 3, separator = '-' },

  keys = {
    {
      '[c',
      function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end,
      desc = 'Go to Context',
      silent = true,
    },
  },

  config = function(_, opts)
    require('treesitter-context').setup(opts)

    -- Use the same background as Normal (for non-transparent mode)
    vim.api.nvim_set_hl(0, 'TreesitterContext', { link = 'Normal' })

    -- Set separator to use Normal's background (keeps FloatBorder foreground for the '-' char)
    local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
    local separator_fg = vim.api.nvim_get_hl(0, { name = 'FloatBorder' }).fg
    vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { fg = separator_fg, bg = normal_bg })
  end,
}
