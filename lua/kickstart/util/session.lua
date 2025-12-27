-- Session management with centralized storage
-- Sessions are stored in ~/.local/share/nvim/sessions/

local M = {}

local session_dir = vim.fn.stdpath 'data' .. '/sessions/'
vim.fn.mkdir(session_dir, 'p')

function M.get_session_file()
  local cwd = vim.fn.getcwd()
  local session_name = cwd:gsub('/', '%%')
  return session_dir .. session_name .. '.vim'
end

-- Check if there are any real file buffers open (not just alpha, empty, or special buffers)
local function has_real_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
      local bufname = vim.api.nvim_buf_get_name(buf)
      -- Skip special buffers (alpha, neo-tree, terminals, etc.)
      if buftype == '' and bufname ~= '' then
        return true
      end
    end
  end
  return false
end

function M.save()
  -- Only save session if there are real file buffers
  if has_real_buffers() then
    vim.cmd('mksession! ' .. vim.fn.fnameescape(M.get_session_file()))
  end
end

function M.restore()
  local session_file = M.get_session_file()
  if vim.fn.filereadable(session_file) == 1 then
    -- Close alpha buffer first if it exists
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
      if ft == 'alpha' then
        vim.api.nvim_buf_delete(buf, { force = true })
        break
      end
    end
    vim.cmd('source ' .. vim.fn.fnameescape(session_file))
  else
    vim.notify('No session found for this directory', vim.log.levels.WARN)
  end
end

-- Auto-save session before quitting
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = M.save,
})

return M
