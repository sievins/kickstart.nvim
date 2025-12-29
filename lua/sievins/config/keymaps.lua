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
vim.keymap.set('n', '<leader>fw', '<cmd>noa w<cr>', { desc = 'Save (no action)' })
vim.keymap.set('v', '<leader>fw', '<cmd>noa w<cr>', { desc = 'Save (no action)' })

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

-- Undo history
vim.keymap.set('n', '<leader>bu', vim.cmd.UndotreeToggle, { desc = 'Undotree' })

------------

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
