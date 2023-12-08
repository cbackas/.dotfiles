vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap left and right keys
vim.keymap.set({ 'n', 'v', 'x' }, 'l', 'h', { noremap = true })
vim.keymap.set({ 'n', 'v', 'x' }, ';', 'l', { noremap = true })
vim.keymap.set({ 'n', 'v', 'x' }, 'h', ';', { noremap = true })

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- i want to be able to press tab in insert mode
vim.keymap.set('i', '<Tab>', '<C-V><Tab>', { noremap = true })

-- Remap for dealing with word wrap
-- allows you to move up and down VISUAL lines without jumping to the next line
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- Go back to previous buffer
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { noremap = true, silent = true })

-- easily execute the q macro on the current line
vim.keymap.set('n', 'Q', '@qj')
-- easily execute the q macro on the current visual selection
vim.keymap.set('x', 'Q', ':norm @q<CR>')
