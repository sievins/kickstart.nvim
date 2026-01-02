-- [[ Setting globals ]]

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o` and `:help option-list`

vim.o.autowrite = true -- Autowrite for some tools (hidden turns this off)
vim.o.breakindent = true -- Wrapped line repeats indent
vim.o.completeopt = 'menu,menuone,noselect' -- Completion in insert mode (show menu, even when one item, don't preselect item)
vim.o.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.o.confirm = true -- Confirmation dialog if performing an operation that would fail due to unsaved changes in the buffer (like `:q`)
vim.o.cursorline = true -- Show which line your cursor is on
vim.o.expandtab = true
vim.o.foldlevel = 99 -- Close folds with a level higher than this
vim.o.foldmethod = 'indent'
vim.o.foldtext = ''
vim.o.formatoptions = 'jcroqlnt/'
vim.o.grepformat = '%f:%l:%c:%m'
vim.o.grepprg = 'rg --vimgrep' -- Program to use for :grep. Add -uu to bipass ignore rules and include hidden files
vim.o.ignorecase = true -- Case-insensitive searching
vim.o.inccommand = 'nosplit' -- Preview substitutions live, as you type
vim.o.jumpoptions = 'stack,view' -- Stack: Discard subsequent entries when going back and adding a new location. View: Preserve position.
vim.o.laststatus = 3 -- Global statusline
vim.o.linebreak = true -- Wrap lines at convenient points
vim.o.list = true -- Sets how neovim will display certain whitespace characters in the editor
vim.o.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example
vim.o.number = true -- Line numbers
vim.o.pumblend = 10 -- Popup blend
vim.o.pumheight = 10 -- Maximum number of entries in a popup
vim.o.relativenumber = true -- Line numbers relative to current line
vim.o.ruler = false -- Disable the default ruler
vim.o.scrolloff = 4 -- Minimal number of screen lines to keep above and below the cursor
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 2 -- Size of an indent
vim.o.showmode = false -- Don't show the mode, since it's already in the status line
vim.o.sidescrolloff = 8 -- Columns of context
vim.o.signcolumn = 'yes' -- Keep signcolumn on by default, otherwise it would shift the text each time
vim.o.smartcase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.smartindent = true -- Insert indents automatically
vim.o.smoothscroll = true -- For when first line is wrapped
vim.o.spelllang = 'en_gb'
vim.o.splitbelow = true -- Configure how new splits should be opened
vim.o.splitkeep = 'screen' -- Keep text on same screen line on splits
vim.o.splitright = true -- Configure how new splits should be opened
vim.o.tabstop = 2 -- Number of spaces tabs count for
vim.o.termguicolors = true -- True color support
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.o.ttimeoutlen = 10 -- Wait less for terminal key-code sequence
vim.o.undofile = true -- Save undo history
vim.o.updatetime = 200 -- Decrease update time (e.g. save swap file)
vim.o.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
vim.o.wildmode = 'longest:full,full' -- Command-line completion mode
vim.o.winminwidth = 5 -- Minimum window width
vim.o.wrap = false -- Disable line wrap
vim.opt.diffopt:append { 'algorithm:histogram', 'indent-heuristic' } -- Diffs line up better
vim.opt.fillchars = { foldopen = '', foldclose = '', fold = ' ', foldsep = ' ', diff = '╱', eob = ' ' }
vim.opt.listchars = { tab = '» ', nbsp = '␣' } -- Sets how neovim will display certain whitespace characters in the editor
vim.opt.sessionoptions = { 'buffers', 'curdir', 'folds', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' } -- Restoring sessions
vim.opt.shortmess:append { W = true, I = true, c = true, C = true } -- Suppress some messages at bottom
vim.schedule(function() -- Schedule the setting after `UiEnter` because it can increase startup-time
  vim.o.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim
end)
