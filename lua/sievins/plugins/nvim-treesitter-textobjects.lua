-- Treesitter-powered textobject movement (functions, classes, parameters)
-- Also provides the `textobjects` queries used by mini.ai's treesitter specs
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter-textobjects').setup {
      move = {
        -- Set jumps in the jumplist
        set_jumps = true,
      },
    }

    -- Buffer-local movement keymaps (ported from LazyVim)
    local moves = {
      goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
      goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
      goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
      goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
    }

    -- Does this buffer's language have `textobjects` queries?
    local function have_textobjects(buf)
      local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
      if not lang then
        return false
      end
      local ok, query = pcall(vim.treesitter.query.get, lang, 'textobjects')
      return ok and query ~= nil
    end

    local function attach(buf)
      if not (vim.api.nvim_buf_is_valid(buf) and have_textobjects(buf)) then
        return
      end
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local desc = query:gsub('@', ''):gsub('%..*', '')
          desc = desc:sub(1, 1):upper() .. desc:sub(2)
          desc = (key:sub(1, 1) == '[' and 'Prev ' or 'Next ') .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and ' End' or ' Start')
          vim.keymap.set({ 'n', 'x', 'o' }, key, function()
            -- Keep native ]c/[c change-jump behavior in diff mode
            if vim.wo.diff and key:find '[cC]' then
              return vim.cmd('normal! ' .. key)
            end
            require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
          end, { buffer = buf, desc = desc, silent = true })
        end
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('sievins-treesitter-textobjects', { clear = true }),
      callback = function(ev)
        attach(ev.buf)
      end,
    })

    -- Attach to buffers opened before this plugin loaded (VeryLazy)
    vim.tbl_map(attach, vim.api.nvim_list_bufs())
  end,
}
