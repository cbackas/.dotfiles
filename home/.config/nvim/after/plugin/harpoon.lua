local harpoon = require('harpoon')

-- initialize harpoon
harpoon.setup {
  tabline = true
}

-- define visual settings for harpoon
local number_color = "#DCDCAA"
local background_color = "#282829"
vim.cmd('highlight! HarpoonInactive guibg=' .. background_color .. ' guifg=#797C91')
vim.cmd('highlight! HarpoonActive guibg=' .. background_color .. ' guifg=#9CDCFE')
vim.cmd('highlight! HarpoonNumberActive guibg=' .. background_color .. ' guifg=' .. number_color)
vim.cmd('highlight! HarpoonNumberInactive guibg=' .. background_color .. ' guifg=' .. number_color)
vim.cmd('highlight! TabLineFill guibg=' .. background_color .. ' guifg=white')

-- define keybindings
vim.keymap.set("n", "<leader>hm",
  function()
    require("harpoon.mark").add_file()
    -- update the tabline to show new mark
    -- idk why this is needed, harpoon bad i guess
    vim.cmd("redrawt")
  end,
  { desc = "Harpoon Mark File" })
vim.keymap.set("n", "<leader>hl", require("harpoon.ui").toggle_quick_menu, { desc = "Harpoon List" })

-- define keybindings for navigation
for i = 1, 8 do
  vim.keymap.set("n", string.format("<M-%s>", i),
    function()
      require("harpoon.ui").nav_file(i)
    end,
    { silent = true, noremap = true }
  )

  vim.keymap.set("n", string.format("<leader>%s", i),
    function()
      require("harpoon.ui").nav_file(i)
    end,
    { silent = true, noremap = true }
  )
end
