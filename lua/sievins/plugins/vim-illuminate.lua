return {
  'RRethy/vim-illuminate',

  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },

  opts = {
    under_cursor = false,
    delay = 200,
    large_file_cutoff = 2000,
    large_file_overrides = {
      providers = { 'lsp' },
    },
  },

  config = function(_, opts)
    require('illuminate').configure(opts)

    local function map(key, dir, buffer)
      vim.keymap.set('n', key, function()
        -- Suppress notification when reaching top/bottom reference.
        -- The cursor not moving is enough context to know we've reached the top/bottom.
        local err_writeln = vim.api.nvim_err_writeln
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.api.nvim_err_writeln = function() end
        require('illuminate')['goto_' .. dir .. '_reference'](false)
        vim.api.nvim_err_writeln = err_writeln
      end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
    end

    map(']]', 'next')
    map('[[', 'prev')

    -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        map(']]', 'next', buffer)
        map('[[', 'prev', buffer)
      end,
    })
  end,

  keys = {
    { ']]', desc = 'Next Reference' },
    { '[[', desc = 'Prev Reference' },
  },
}
