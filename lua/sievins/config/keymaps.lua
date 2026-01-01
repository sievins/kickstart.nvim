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
-- Split and move current buffer to new split, show previous buffer in original window
local function split_with_prev_buffer(split_cmd)
  local current_buf = vim.api.nvim_get_current_buf()
  local prev_buf = sievins.bufhistory.get_previous()

  -- Split creates new window and moves cursor there
  vim.cmd(split_cmd)

  -- Go back to original window
  vim.cmd 'wincmd p'

  -- Set previous buffer in original window (if available)
  if prev_buf and prev_buf ~= current_buf then
    vim.api.nvim_set_current_buf(prev_buf)
  end
end

vim.keymap.set('n', '<leader>-', function()
  split_with_prev_buffer 'split'
end, { desc = 'Split Window Below' })
vim.keymap.set('n', '<leader>|', function()
  split_with_prev_buffer 'vsplit'
end, { desc = 'Split Window Right' })
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

-- Center window toggle
do
  local enabled = false
  local augroup = vim.api.nvim_create_augroup('CenterWindow', { clear = true })
  local text_width = 100

  vim.keymap.set('n', '<leader>wc', function()
    enabled = not enabled

    if enabled then
      local function update_statuscolumn()
        local winwidth = vim.api.nvim_win_get_width(0)
        local full_screen = vim.o.columns
        local padding = math.min(40, math.max(0, math.floor((winwidth - text_width) / 2)))
        if winwidth > (full_screen / 2) then
          vim.wo.statuscolumn = string.rep(' ', padding) .. '%s%l '
        else
          vim.wo.statuscolumn = ''
        end
      end

      update_statuscolumn()

      vim.api.nvim_create_autocmd({
        'BufEnter',
        'BufWinEnter',
        'BufWinLeave',
        'WinEnter',
        'WinLeave',
        'WinResized',
        'VimResized',
      }, {
        group = augroup,
        callback = update_statuscolumn,
      })
    else
      vim.api.nvim_clear_autocmds { group = augroup }
      vim.o.statuscolumn = ''
      -- Reset statuscolumn for all buffers (Neovim stores per-buffer window options)
      local current_buf = vim.api.nvim_get_current_buf()
      vim.cmd 'silent! noautocmd bufdo setlocal statuscolumn='
      vim.api.nvim_set_current_buf(current_buf)
    end
  end, { desc = 'Center window toggle' })
end

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

-- Delete file
vim.keymap.set('n', '<leader>fd', function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then
    vim.notify('No file to delete', vim.log.levels.WARN)
    return
  end
  vim.ui.select({ 'Yes', 'No' }, { prompt = 'Delete ' .. path .. '?' }, function(choice)
    if choice == 'Yes' then
      os.remove(path)
      sievins.bufdelete()
      vim.notify('Deleted ' .. path)
    end
  end)
end, { desc = 'Delete File' })

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

-- Toggles
vim.keymap.set('n', '<leader>ts', '<cmd>set spell!<cr>', { desc = 'Toggle Spelling' })
vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<cr>', { desc = 'Toggle Wrap' })

-- TODO: Install Snacks
-- Git
-- vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
-- vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
-- vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
-- vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = "Git Log" })
-- vim.keymap.set({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
-- vim.keymap.set({"n", "x" }, "<leader>gY", function()
--   Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
-- end, { desc = "Git Browse (copy)" })
