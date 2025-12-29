return {
  {
    'mbbill/undotree',

    keys = {
      { '<leader>bu', '<cmd>UndotreeToggle<cr>', desc = 'Undotree' },
    },

    init = function()
      vim.g.undotree_WindowLayout = 4
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
}
