return {
  'ibhagwan/smartyank.nvim',
  opts = {
    -- our own TextYankPost autocmd (init.lua) already highlights yanks via the
    -- non-deprecated vim.hl.hl_op; smartyank's highlight uses the deprecated
    -- vim.hl.on_yank, so turn it off to kill the warning (and the double-flash).
    highlight = { enabled = false },
    osc52 = {
      enabled = true,
      ssh_only = false,      -- false to OSC52 yank also in local sessions
      silent = false,        -- true to disable the "n chars copied" echo
      echo_hl = "Directory", -- highlight group of the OSC52 echo message
    }
  }
}
