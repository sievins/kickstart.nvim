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

-- Windows
vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
vim.keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })

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

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- n always search forward and N backward
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Save file
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

--Keyword Manuel
vim.keymap.set('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keyword Manual' })

-- Better indenting
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- Lazy
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- New file
vim.keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

-- Quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

-- Location list
vim.keymap.set('n', '<leader>xl', function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Location List' })

-- Quickfix list
vim.keymap.set('n', '<leader>xq', function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Quickfix List' })

vim.keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
vim.keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- Diagnostic
vim.keymap.set('n', '<leader>xx', vim.diagnostic.setloclist, { desc = 'Diagnostics' })
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump {
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    }
  end
end
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })
