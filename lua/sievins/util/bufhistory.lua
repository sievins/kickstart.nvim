---@class sievins.bufhistory
local M = {}

-- History stack of buffer numbers (most recent at end)
local history = {}
-- Current position in history (nil = at head)
local position = nil
-- Flag to prevent recording when navigating
local navigating = false

local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
end

local function cleanup_history()
  history = vim.tbl_filter(is_valid_buf, history)
end

--- Record a buffer visit (called by autocmd)
function M.record(buf)
  if navigating then
    return
  end

  buf = buf or vim.api.nvim_get_current_buf()
  if not is_valid_buf(buf) then
    return
  end

  -- Remove buf if already in history
  history = vim.tbl_filter(function(b)
    return b ~= buf
  end, history)

  -- Add to end (most recent)
  table.insert(history, buf)
  position = nil -- Reset position when manually switching
end

--- Navigate backward in history
function M.back()
  cleanup_history()
  if #history <= 1 then
    return
  end

  local current = vim.api.nvim_get_current_buf()

  -- Initialize position if needed
  if position == nil then
    -- Find current buffer in history
    for i = #history, 1, -1 do
      if history[i] == current then
        position = i
        break
      end
    end
  end

  if position == nil or position <= 1 then
    return -- Already at oldest
  end

  position = position - 1
  navigating = true
  vim.api.nvim_set_current_buf(history[position])
  navigating = false
end

--- Navigate forward in history
function M.forward()
  cleanup_history()
  if #history <= 1 or position == nil then
    return
  end

  if position >= #history then
    return -- Already at newest
  end

  position = position + 1
  navigating = true
  vim.api.nvim_set_current_buf(history[position])
  navigating = false
end

--- Setup autocmd to track buffer changes
function M.setup()
  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('sievins-bufhistory', { clear = true }),
    callback = function(ev)
      M.record(ev.buf)
    end,
  })
end

return M
