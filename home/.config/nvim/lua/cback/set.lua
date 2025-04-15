vim.o.shortmess = vim.o.shortmess .. "I"

-- Set highlight on search
vim.o.hlsearch = true

-- enable relative line numbers
-- vim.wo.number = true
-- vim.opt.nu = true
-- vim.opt.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.cursorline = true
vim.wo.signcolumn = 'yes'
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.statuscolumn = '%s' ..
    '%=%{printf("%4d", v:relnum?v:relnum:v:lnum)}' ..
    '%{foldlevel(v:lnum)>0?(foldclosed(v:lnum)==-1?" ":"▸"):" "} '

-- Decrease update time
vim.o.updatetime = 300
vim.o.timeoutlen = 250

-- expand tabs to spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.expandtab = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.winborder = 'rounded'

-- Splits should open to the bottom
vim.o.splitbelow = true

vim.opt.wrap = false

vim.opt.swapfile = false

-- Undofile stuff
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- disable the netrw banner even tho netrw is disabled via oil
vim.g.netrw_banner = 0

-- the coverage plugin needs this to find the coverage files
vim.g.coverage_json_report_path = 'coverage/coverage-final.json'

-- add some usefull abbreviations for the command line
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev Q q")
