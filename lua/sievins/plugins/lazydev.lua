-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
-- used for completion, annotations and signatures of Neovim apis
-- https://github.com/folke/lazydev.nvim

return {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      -- Load snacks.nvim types when the `Snacks` word is found
      { path = 'snacks.nvim', words = { 'Snacks' } },
      -- Load which-key.nvim types when a `wk.` doc name is found (e.g. `wk.Spec`)
      { path = 'which-key.nvim', words = { 'wk%.' } },
    },
  },
}
