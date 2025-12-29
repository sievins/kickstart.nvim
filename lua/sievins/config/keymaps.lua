-- [[ Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set keymap for normal windows only (e.g. not quickfix)
local normal_window_keymap = function(mode, lhs, rhs, opts)
  local merged_opts = vim.tbl_extend('force', { noremap = true, expr = true }, opts or {})

  vim.keymap.set(mode, lhs, function()
    local buftype = vim.fn.win_gettype()
    return buftype == '' and rhs or lhs
  end, merged_opts)
end

-- Add new line (like o/O) without moving the cursor, without entering insert mode and removing any characters
normal_window_keymap('n', '<CR>', 'mao<esc>0<S-d>`a<cmd>delmarks a<cr>', { desc = 'Add new line below' })
normal_window_keymap('n', '<S-CR>', 'maO<esc>0<S-d>`a<cmd>delmarks a<cr>', { desc = 'Add new line above' })

-- Save with no action
vim.keymap.set({ 'n', 'x' }, '<leader>fw', '<cmd>noa w<cr>', { desc = 'Save (no action)' })

-- Better up/down for wrapped lines
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move lines
vim.keymap.set('v', '<C-down>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<C-up>', ":m '<-2<CR>gv=gv")

-- Move focus to window using the <ctrl> arrow keys
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-left>', '<C-w>h', { desc = 'Go to left window', remap = true })
vim.keymap.set('n', '<C-right>', '<C-w>l', { desc = 'Go to right window', remap = true })
vim.keymap.set('n', '<C-up>', '<C-w>k', { desc = 'Go to upper window', remap = true })
vim.keymap.set('n', '<C-down>', '<C-w>j', { desc = 'Go to lower window', remap = true })
vim.keymap.set('t', '<C-left>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-right>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
vim.keymap.set('t', '<C-up>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-down>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Go to right window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Go to lower window' })
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })

-- Buffers (navigate by history)
sievins.bufhistory.setup()

vim.keymap.set('n', '[b', function()
  sievins.bufhistory.back()
end, { desc = 'Prev Buffer (history)' })
vim.keymap.set('n', ']b', function()
  sievins.bufhistory.forward()
end, { desc = 'Next Buffer (history)' })
vim.keymap.set('n', '<leader>bd', function()
  sievins.bufdelete()
end, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bo', function()
  sievins.bufdelete.other()
end, { desc = 'Delete Other Buffers' })
vim.keymap.set('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })

-- Undo history
vim.keymap.set('n', '<leader>bu', vim.cmd.UndotreeToggle, { desc = 'Undotree' })

-- Paste/Delete/Change and preserve original copy
local function paste_preserve()
  -- Delete selection into the black-hole register
  vim.cmd [[normal! "_d]]

  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] -- 0-based

  -- If line ends with whitespace and cursor is on that last char, paste *after* it
  if #line > 0 and col == #line - 1 and line:sub(#line, #line):match '%s' then
    vim.cmd 'normal! p'
  else
    vim.cmd 'normal! P'
  end
end
vim.keymap.set({ 'n', 'x' }, '<leader>p', paste_preserve, { desc = 'Paste (preserve copy)' })
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', { desc = 'Delete (black hole)' })
vim.keymap.set('n', '<leader>dd', '"_dd', { desc = 'Delete line (black hole)' })
vim.keymap.set('n', '<leader>D', '"_D', { desc = 'Delete to EOL (black hole)' })
vim.keymap.set({ 'n', 'x' }, 'x', '"_x', { desc = 'Delete char (black hole)' })
vim.keymap.set({ 'n', 'x' }, 'X', '"_X', { desc = 'Delete char back (black hole)' })
vim.keymap.set({ 'n', 'x' }, 'c', '"_c', { desc = 'Change (black hole)' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfi[x] list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
