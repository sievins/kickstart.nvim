return {
  {
    'xiyaowong/nvim-transparent',

    lazy = false, -- Load before alpha so dashboard is transparent

    opts = {
      extra_groups = {
        'NormalFloat', -- plugins which have float panel such as Lazy, Mason, LspInfo
        'NvimTreeNormal', -- NvimTree
        -- Alpha dashboard
        'AlphaHeader',
        'AlphaButtons',
        'AlphaFooter',
        'AlphaShortcut',
      },
    },

    config = function(_, opts)
      local transparent = require 'transparent'
      transparent.setup(opts)

      -- Clear prefixes if starting transparent
      if vim.g.transparent_enabled then
        transparent.clear_prefix 'NeoTree'
        transparent.clear_prefix 'lualine'
        transparent.clear_prefix 'Alpha'
      end
    end,

    keys = {
      {
        '<leader>t',
        function()
          local transparent = require 'transparent'
          vim.cmd 'TransparentToggle'

          if vim.g.transparent_enabled then
            -- Going transparent - clear the prefixes
            transparent.clear_prefix 'NeoTree'
            transparent.clear_prefix 'lualine'
            transparent.clear_prefix 'Alpha'
          else
            -- Going opaque - restore NeoTree highlights
            vim.api.nvim_set_hl(0, 'NeoTreeNormal', { link = 'Normal' })
            vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { link = 'Normal' })
            vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { link = 'Normal' })
          end
        end,
        desc = 'Toggle Transparency',
      },
    },
  },
}
