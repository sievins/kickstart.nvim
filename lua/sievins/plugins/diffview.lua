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

    -- Close the view with q from any Diffview buffer.
    -- Note: q shadows macro recording inside diff buffers.
    keymaps = {
      view = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
      },
      file_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
      },
      file_history_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
      },
    },
  },

  keys = {
    {
      '<leader>gdd',
      function()
        local lib = require 'diffview.lib'
        if lib.get_current_view() then
          vim.cmd 'DiffviewClose'
        elseif #lib.views > 0 then
          -- A view is open in another tabpage; jump there and close it
          vim.api.nvim_set_current_tabpage(lib.views[1].tabpage)
          vim.cmd 'DiffviewClose'
        else
          vim.cmd 'DiffviewOpen'
        end
      end,
      desc = 'Diff repo',
    },
    { '<leader>glh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File History (current file)' },
    { '<leader>glH', '<cmd>DiffviewFileHistory<cr>', desc = 'File History (tree)' },
  },
}
