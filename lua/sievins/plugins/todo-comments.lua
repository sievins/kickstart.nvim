-- Highlight todo, notes, etc in comments
-- https://github.com/folke/todo-comments.nvim

return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = false },
  keys = {
    {
      ']t',
      function()
        require('todo-comments').jump_next()
      end,
      desc = 'Next todo comment',
    },
    {
      '[t',
      function()
        require('todo-comments').jump_prev()
      end,
      desc = 'Previous todo comment',
    },
    { '<leader>st', '<cmd>Trouble todo<cr>', desc = 'Todo' },
  },
}
