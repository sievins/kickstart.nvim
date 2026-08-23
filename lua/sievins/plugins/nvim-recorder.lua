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
          -- Must be the literal typed key: the plugin strips this key from the
          -- end of the recorded register, so an indirect mapping (e.g. <Plug>)
          -- corrupts recordings.
          startStopRecording = 'q',
          playMacro = 'Q',
        },
        -- Disable all notifications. Showing in lualine instead.
        logLevel = vim.log.levels.DEBUG,
      }

      -- Refresh lualine when recording starts/stops. Scheduled because
      -- RecordingLeave fires before reg_recording() is cleared.
      vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
        group = vim.api.nvim_create_augroup('sievins-recorder-lualine', { clear = true }),
        callback = function()
          vim.schedule(function()
            require('lualine').refresh()
          end)
        end,
      })
    end,
  },
}
