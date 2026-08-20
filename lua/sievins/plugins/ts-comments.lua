-- Pick the right commentstring per treesitter node, e.g. {/* */} inside JSX
-- https://github.com/folke/ts-comments.nvim

return {
  'folke/ts-comments.nvim',
  event = 'VeryLazy',
  opts = {},
}
