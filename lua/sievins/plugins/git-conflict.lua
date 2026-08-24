-- Highlight and resolve inline merge conflict markers
-- https://github.com/akinsho/git-conflict.nvim
--
-- Default mappings are off: `c` is remapped to black-hole change and `ct{char}` is a real motion.
-- `m` = merge conflict. `]m`/`[m` shadow the built-in method motions; treesitter's `]f`/`[f` cover those.

return {
  'akinsho/git-conflict.nvim',
  version = '*',
  event = 'BufReadPre',
  opts = { default_mappings = false, default_commands = true },
  keys = {
    { ']m', '<cmd>GitConflictNextConflict<cr>', desc = 'Next Conflict' },
    { '[m', '<cmd>GitConflictPrevConflict<cr>', desc = 'Prev Conflict' },
    { '<leader>gmo', '<cmd>GitConflictChooseOurs<cr>', desc = 'Choose Ours' },
    { '<leader>gmt', '<cmd>GitConflictChooseTheirs<cr>', desc = 'Choose Theirs' },
    { '<leader>gmb', '<cmd>GitConflictChooseBoth<cr>', desc = 'Choose Both' },
    { '<leader>gmn', '<cmd>GitConflictChooseNone<cr>', desc = 'Choose None' },
    { '<leader>gmq', '<cmd>GitConflictListQf<cr>', desc = 'Conflicts to Quickfix' },
  },
}
