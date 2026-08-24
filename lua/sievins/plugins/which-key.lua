-- Show available keybindings in popup
-- https://github.com/folke/which-key.nvim

return {
  'folke/which-key.nvim',

  event = 'VeryLazy',

  opts_extend = { 'spec' },

  opts = {
    preset = 'helix',
    -- Keep <C-d>/<C-u> out of which-key's key tree so they scroll the popup
    -- even at the root, where neoscroll's mappings would otherwise win.
    -- Outside the popup neoscroll behaves as normal.
    filter = function(mapping)
      local lhs = vim.fn.keytrans(vim.keycode(mapping.lhs))
      return lhs ~= '<C-D>' and lhs ~= '<C-U>'
    end,
    spec = {
      {
        mode = { 'n', 'x' },
        { '<leader>c', group = 'code' },
        { '<leader>ci', group = 'imports' },
        { '<leader>d', group = 'debug' },
        { '<leader>f', group = 'file/find' },
        { '<leader>g', group = 'git' },
        { '<leader>h', group = 'harpoon' },
        { '<leader>gh', group = 'hunks' },
        { '<leader>gd', group = 'diff' },
        { '<leader>gl', group = 'history' },
        { '<leader>go', group = 'github' },
        { '<leader>gm', group = 'merge conflict' },
        { '<leader>q', group = 'quit/session' },
        { '<leader>s', group = 'search' },
        { '<leader>t', group = 'toggle' },
        { '<leader>x', group = 'lists' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'ga', group = 'calls' },
        -- Hide default Neovim 0.11+ LSP keymaps so gr doesn't appear as a group
        { 'grr', hidden = true },
        { 'grn', hidden = true },
        { 'gri', hidden = true },
        { 'gra', hidden = true },
        { 'grt', hidden = true },
        -- Hide harpoon file selections 2-9 to reduce clutter (keymaps still work)
        { '<leader>2', hidden = true },
        { '<leader>3', hidden = true },
        { '<leader>4', hidden = true },
        { '<leader>5', hidden = true },
        { '<leader>6', hidden = true },
        { '<leader>7', hidden = true },
        { '<leader>8', hidden = true },
        { '<leader>9', hidden = true },
        { 'gs', group = 'surround' },
        { 'z', group = 'fold' },
        {
          '<leader>b',
          group = 'buffer',
          expand = function()
            return require('which-key.extras').expand.buf()
          end,
        },
        {
          '<leader>w',
          group = 'windows',
          proxy = '<c-w>',
          expand = function()
            return require('which-key.extras').expand.win()
          end,
        },
      },
    },

    icons = {
      -- Set icon mappings to true if you have a Nerd Font
      mappings = vim.g.have_nerd_font,
      -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
      -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },
  },
  keys = {
    {
      '<c-w><space>',
      function()
        require('which-key').show { keys = '<c-w>', loop = true }
      end,
      desc = 'Window Hydra Mode (which-key)',
    },
  },
}
