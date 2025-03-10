return {
  'vyfor/cord.nvim',
  build = ':Cord update',
  cond = function()
    local enable_rpc = os.getenv('ENABLE_NVIM_DISCORD_RPC')
    return enable_rpc == '1' or enable_rpc == 'yes' or enable_rpc == 'true'
  end,
  opts = {
    display = {
      swap_icons = true
    },
    timestamp = {
      enabled = false
    },
    idle = {
      show_status = false,
      timeout = 150000
    },
  }
}
