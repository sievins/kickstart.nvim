return {
  'brenoprata10/nvim-highlight-colors',

  config = function(_, opts)
    require('nvim-highlight-colors').setup(opts)
  end,

  -- TODO: csp and lsp integration
}
