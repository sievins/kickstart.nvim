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
        -- `silent!` suppresses the "hit BOTTOM/TOP of the references" message.
        -- The cursor not moving is enough context to know we've reached the top/bottom.
        vim.cmd(('silent! lua require("illuminate").goto_%s_reference(false)'):format(dir))
      end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
    end

    map(']]', 'next')
    map('[[', 'prev')

    -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('illuminate_keymaps', { clear = true }),
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
