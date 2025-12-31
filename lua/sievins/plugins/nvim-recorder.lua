return {
  {
    'chrisgrieser/nvim-recorder',

    dependencies = 'rcarriga/nvim-notify',

    event = 'VeryLazy',

    keys = {
      -- These must match the keys in the mapping config below, and are required
      -- so that keymaps are included in which-key given the plugin is lazy loaded.
      { 'q', desc = ' Start Recording' },
      { 'Q', desc = ' Play Recording' },
    },

    config = function()
      local recorder = require 'recorder'

      ---@diagnostic disable-next-line: missing-fields
      recorder.setup {
        ---@diagnostic disable-next-line: missing-fields
        mapping = {
          startStopRecording = '<Plug>(recorder-record)',
          playMacro = 'Q',
        },
        -- Disable all notifications. Showing in lualine instead.
        logLevel = vim.log.levels.DEBUG,
      }

      -- Wrap recorder mappings to refresh lualine
      local function withRefresh(plug)
        return function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(plug, true, false, true), 'm', false)
          vim.schedule(function()
            require('lualine').refresh()
          end)
        end
      end

      vim.keymap.set('n', 'q', withRefresh '<Plug>(recorder-record)', { desc = ' Start Recording' })
    end,
  },
}
