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
        'TreesitterContext',
        'TreesitterContextSeparator',
      },
      exclude_groups = {
        'BlinkCmpScrollBarThumb',
        'BlinkCmpScrollBarGutter',
        'BlinkCmpMenuSelection',
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
        transparent.clear_prefix 'Fidget'
        transparent.clear_prefix 'Noice'
        transparent.clear_prefix 'Notify'
        transparent.clear_prefix 'BlinkCmp'
      end
    end,

    keys = {
      {
        '<leader>tt',
        function()
          local transparent = require 'transparent'
          vim.cmd 'TransparentToggle'

          if vim.g.transparent_enabled then
            -- Going transparent - clear the prefixes
            transparent.clear_prefix 'NeoTree'
            transparent.clear_prefix 'lualine'
            transparent.clear_prefix 'Alpha'
            transparent.clear_prefix 'Fidget'
            transparent.clear_prefix 'Noice'
            transparent.clear_prefix 'Notify'
            transparent.clear_prefix 'BlinkCmp'
          else
            -- Going opaque - restore highlights
            vim.api.nvim_set_hl(0, 'NeoTreeNormal', { link = 'Normal' })
            vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { link = 'Normal' })
            vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { link = 'Normal' })

            -- Restore TreesitterContext highlights
            vim.api.nvim_set_hl(0, 'TreesitterContext', { link = 'Normal' })
            local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
            local separator_fg = vim.api.nvim_get_hl(0, { name = 'FloatBorder' }).fg
            vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { fg = separator_fg, bg = normal_bg })
          end
        end,
        desc = 'Toggle Transparency',
      },
    },
  },
}
