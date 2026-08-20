-- Highlight and resolve inline merge conflict markers
-- https://github.com/akinsho/git-conflict.nvim
--
-- Default mappings are off: `c` is remapped to black-hole change and `ct{char}` is a real motion.

return {
  'akinsho/git-conflict.nvim',
  version = '*',
  event = 'BufReadPre',
  opts = { default_mappings = false, default_commands = true },
  keys = {
    { ']x', '<cmd>GitConflictNextConflict<cr>', desc = 'Next Conflict' },
    { '[x', '<cmd>GitConflictPrevConflict<cr>', desc = 'Prev Conflict' },
    { '<leader>gxo', '<cmd>GitConflictChooseOurs<cr>', desc = 'Choose Ours' },
    { '<leader>gxt', '<cmd>GitConflictChooseTheirs<cr>', desc = 'Choose Theirs' },
    { '<leader>gxb', '<cmd>GitConflictChooseBoth<cr>', desc = 'Choose Both' },
    { '<leader>gx0', '<cmd>GitConflictChooseNone<cr>', desc = 'Choose None' },
    { '<leader>gxq', '<cmd>GitConflictListQf<cr>', desc = 'Conflicts to Quickfix' },
  },
}
