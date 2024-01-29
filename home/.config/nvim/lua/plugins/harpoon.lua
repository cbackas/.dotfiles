local init = function()
  local harpoon = require('harpoon')

  -- define keybindings
  vim.keymap.set("n", "<leader>hm",
    function()
      harpoon:list():append()
      -- update the tabline to show new mark
      -- idk why this is needed, harpoon bad i guess
      vim.cmd("redrawt")
    end,
    { desc = "Harpoon Mark File" })
  vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    { desc = "Harpoon List" })

  -- define keybindings for navigation
  for i = 1, 8 do
    vim.keymap.set("n", string.format("<M-%s>", i),
      function()
        harpoon:list():select(i)
      end,
      { silent = true, noremap = true }
    )

    vim.keymap.set("n", string.format("<leader>%s", i),
      function()
        harpoon:list():select(i)
      end,
      { silent = true, noremap = true }
    )
  end
end

return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  branch = "harpoon2",
  config = function()
    require('harpoon'):setup()
  end,
  init = init
}
