local harpoon = require('harpoon')

-- initialize harpoon
harpoon.setup {
  tabline = true
}

-- define visual settings for harpoon
local number_color = "#DCDCAA"
local background_color = "#282829"
vim.cmd('highlight! HarpoonInactive guibg=' .. background_color ..' guifg=#797C91')
vim.cmd('highlight! HarpoonActive guibg=' .. background_color ..' guifg=#9CDCFE')
vim.cmd('highlight! HarpoonNumberActive guibg=' .. background_color ..' guifg=' .. number_color)
vim.cmd('highlight! HarpoonNumberInactive guibg=' .. background_color ..' guifg=' .. number_color)
vim.cmd('highlight! TabLineFill guibg=' .. background_color .. ' guifg=white')

-- define keybindings
vim.keymap.set("n", "<leader>hm", require("harpoon.mark").add_file, { desc = "Harpoon Mark File" })
vim.keymap.set("n", "<leader>hl", require("harpoon.ui").toggle_quick_menu, { desc = "Harpoon List" })

-- define keybindings for navigation
for i = 1, 8 do
  vim.keymap.set("n", string.format("<space>%s", i),
    function()
      require("harpoon.ui").nav_file(i)
    end,
    { desc = "Harpoon Nav Mark " .. i }
  )
end
