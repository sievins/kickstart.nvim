-- Single tabpage interface for cycling through diffs of all modified files
-- https://github.com/sindrets/diffview.nvim

return {
  'sindrets/diffview.nvim',

  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewFileHistory',
  },

  opts = {
    enhanced_diff_hl = true,

    hooks = {
      -- Show the whole file with full context instead of only the hunks.
      -- Native diff-mode folds unchanged regions by default; disable folding
      -- in diff buffers so unchanged lines stay visible (GitHub-style).
      diff_buf_read = function()
        vim.opt_local.foldenable = false
      end,
    },
  },

  keys = {
    { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = 'Diffview Open' },
    { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = 'Diffview Close' },
    { '<leader>gdh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File History (current file)' },
    { '<leader>gdH', '<cmd>DiffviewFileHistory<cr>', desc = 'File History (tree)' },
  },
}
