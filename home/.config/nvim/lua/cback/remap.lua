vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap left and right keys
-- For normal mode
vim.api.nvim_set_keymap('n', 'l', 'h', { noremap = true })
vim.api.nvim_set_keymap('n', ';', 'l', { noremap = true })
vim.api.nvim_set_keymap('n', 'h', ';', { noremap = true })
-- For selection mode
vim.api.nvim_set_keymap('x', 'l', 'h', { noremap = true })
vim.api.nvim_set_keymap('x', ';', 'l', { noremap = true })
vim.api.nvim_set_keymap('x', 'h', ';', { noremap = true })
-- For visual mode
vim.api.nvim_set_keymap('v', 'l', 'h', { noremap = true })
vim.api.nvim_set_keymap('v', ';', 'l', { noremap = true })
vim.api.nvim_set_keymap('v', 'h', ';', { noremap = true })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.api.nvim_set_keymap('n', '<leader>bd', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>be', ":lua vim.cmd('bd | Explore ' .. vim.fn.expand('%:p:h'))<CR>",
  { noremap = true, silent = true })
