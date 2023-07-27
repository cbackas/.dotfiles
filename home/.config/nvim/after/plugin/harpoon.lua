local harpoon = require('harpoon')

harpoon.setup {}

vim.keymap.set("n", "<leader>hm", require("harpoon.mark").add_file)
vim.keymap.set("n", "<leader>hl", require("harpoon.ui").toggle_quick_menu)

for i = 1, 5 do
  vim.keymap.set("n", string.format("<space>%s", i),
    function()
      require("harpoon.ui").nav_file(i)
    end
  )
end
