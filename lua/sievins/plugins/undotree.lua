return {
  {
    'mbbill/undotree',

    event = 'VeryLazy',

    init = function()
      vim.g.undotree_WindowLayout = 4
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
}
