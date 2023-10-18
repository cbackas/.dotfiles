-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- status culumn is to the right of the line numbers
-- sign column is to the left of the line numbers
-- this makes it use that instead of the signcolumn
-- vim.wo.signcolumn = 'yes'
vim.opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} %s"

-- Decrease update time
vim.o.updatetime = 300
vim.o.timeoutlen = 250

-- expand tabs to spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Set completeopt to have a better complftion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Splits should open to the bottom
vim.o.splitbelow = true

vim.opt.wrap = false

vim.opt.swapfile = false

-- Undofile stuff
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- relativenumber stuff
vim.opt.nu = true
vim.opt.relativenumber = true

vim.g.netrw_banner = 0

vim.g.coverage_json_report_path = 'coverage/coverage-final.json'
