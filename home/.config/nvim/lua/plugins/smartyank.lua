return {
  'ibhagwan/smartyank.nvim',
  opts = {
    osc52 = {
      enabled = true,
      ssh_only = false,      -- false to OSC52 yank also in local sessions
      silent = false,        -- true to disable the "n chars copied" echo
      echo_hl = "Directory", -- highlight group of the OSC52 echo message
    }
  }
}
