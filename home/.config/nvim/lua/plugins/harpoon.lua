local init = function()
  local harpoon = require('harpoon')

  -- define keybindings
  vim.keymap.set("n", "<leader>hm",
    function()
      harpoon:list():add()
      -- update the tabline to show new mark
      -- idk why this is needed, harpoon bad i guess
      vim.cmd("redrawt")
    end,
    { desc = "Harpoon Mark File" })
  vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    { desc = "Harpoon List" })

  -- define keybindings for navigation
  for i = 1, 9 do
    vim.keymap.set("n", string.format("<M-%s>", i),
      function()
        harpoon:list():select(i)
      end,
      { silent = true, noremap = true, desc = "Harpoon mark " .. i }
    )
  end

  vim.keymap.set("n", "<M-`>", function()
    vim.print("ya motha")
    require("oil").open(vim.fn.getcwd())
  end, { silent = true, noremap = true, desc = "Open project CWD with oil" })
end

return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  branch = "harpoon2",
  opts = {
    default = {
      display = function(list_item)
        local is_oil = vim.startswith(list_item.value, "oil")
        if is_oil then
          return "[" .. vim.fn.fnamemodify(string.sub(list_item.value, 7), ":.") .. "]"
        else
          return list_item.value
        end
      end
    }
  },
  config = function(_, opts)
    require('harpoon'):setup(opts)
  end,
  init = init
}
