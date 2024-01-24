local M = {
  "mbbill/undotree",
  init = function()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
  end
}

return { M }
