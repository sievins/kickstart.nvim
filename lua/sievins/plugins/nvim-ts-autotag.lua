-- Auto-close and auto-rename HTML/JSX tags using treesitter
-- https://github.com/windwp/nvim-ts-autotag

return {
  'windwp/nvim-ts-autotag',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {},
}
