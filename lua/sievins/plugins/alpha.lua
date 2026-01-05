-- A splash page plugin with Matrix-style animation
-- https://github.com/goolord/alpha-nvim
-- Requires: https://github.com/st3w/neo for animation

return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    require 'alpha.term' -- Required for terminal-type elements

    -- Check if neo command is available
    local term_height = 12
    local header
    local ret = os.execute 'command -v neo &>/dev/null'

    if ret == 0 then
      -- Matrix terminal animation
      header = {
        type = 'terminal',
        command = "neo --speed=5 --defaultbg --message 'NEO VIM' --density 0.5 --lingerms 1,1",
        width = 46,
        height = term_height,
        opts = {
          redraw = true,
          window_config = {},
        },
      }
    else
      -- Fallback ASCII art
      header = {
        type = 'text',
        val = {
          '    ██╗███████╗███████╗██╗   ██╗███████╗    ███████╗ █████╗ ██╗   ██╗███████╗███████╗',
          '    ██║██╔════╝██╔════╝██║   ██║██╔════╝    ██╔════╝██╔══██╗██║   ██║██╔════╝██╔════╝',
          '    ██║█████╗  ███████╗██║   ██║███████╗    ███████╗███████║██║   ██║█████╗  ███████╗',
          '██   ██║██╔══╝  ╚════██║██║   ██║╚════██║    ╚════██║██╔══██║╚██╗ ██╔╝██╔══╝  ╚════██║',
          '╚█████╔╝███████╗███████║╚██████╔╝███████║    ███████║██║  ██║ ╚████╔╝ ███████╗███████║',
          '╚════╝ ╚══════╝╚══════╝ ╚═════╝ ╚══════╝    ╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝',
        },
        opts = { position = 'center', hl = 'Type' },
      }
    end

    -- Helper to create buttons with colored icons
    local function button(sc, icon, txt, keybind)
      local btn = dashboard.button(sc, icon .. '   ' .. txt, keybind)
      btn.opts.hl = {
        { 'Function', 0, #icon }, -- Icon color
        { 'String', #icon + 3, -1 }, -- Description color
      }
      btn.opts.hl_shortcut = 'Number' -- Orange-like color
      return btn
    end

    -- Minimal button set
    local buttons = {
      type = 'group',
      val = {
        button('s', '', 'Restore Session', '<cmd>lua require("persistence").load()<CR>'),
        button('f', '', 'Find File', '<cmd>lua Snacks.picker.files()<CR>'),
        button('r', '', 'Recent Files', '<cmd>lua Snacks.picker.recent()<CR>'),
        button('n', '', 'New File', '<cmd>ene | startinsert<CR>'),
        button('g', '', 'Find Text', '<cmd>lua Snacks.picker.grep()<CR>'),
        button('l', '󰒲', 'Lazy', '<cmd>Lazy<CR>'),
        button('q', '', 'Quit', '<cmd>qa<CR>'),
      },
      opts = { spacing = 1 },
    }

    -- Layout
    local config = {
      layout = {
        { type = 'padding', val = ret == 0 and (25 - term_height) or 2 },
        header,
        { type = 'padding', val = 4 },
        buttons,
      },
    }

    alpha.setup(config)

    -- Hide cursor on alpha dashboard
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = function()
        vim.opt.guicursor = 'a:Cursor/lCursor'
        vim.cmd 'hi Cursor blend=100'
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaClosed',
      callback = function()
        vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
        vim.cmd 'hi Cursor blend=0'
      end,
    })
  end,
}
