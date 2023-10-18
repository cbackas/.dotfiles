vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap left and right keys
vim.keymap.set({ 'n', 'v', 'x' }, 'l', 'h', { noremap = true })
vim.keymap.set({ 'n', 'v', 'x' }, ';', 'l', { noremap = true })
vim.keymap.set({ 'n', 'v', 'x' }, 'h', ';', { noremap = true })

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Format and save
vim.keymap.set("n", "<leader>ff", function()
  vim.lsp.buf.format()
  vim.cmd('write')

  -- Re-enable diagnostics, following this:
  -- https://www.reddit.com/r/neovim/comments/15dfx4g/help_lsp_diagnostics_are_not_being_displayed/?utm_source=share&utm_medium=web2x&context=3
  vim.diagnostic.enable(0)
end, { noremap = true, silent = true })

-- i want to be able to press tab in insert mode
vim.keymap.set('i', '<Tab>', '<C-V><Tab>', { noremap = true })

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
