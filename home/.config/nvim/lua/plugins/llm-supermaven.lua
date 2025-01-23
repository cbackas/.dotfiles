return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      ignore_filetypes = { dotenv = true },
      keymaps = {
        accept_suggestion = "<C-y>",
      },
      disable_keymaps = true,
    })
  end,
  cond = function()
    -- if 'ENABLE_SUPERMAVEN' env var isn't true, don't load the plugin
    local enable_supermaven = os.getenv('ENABLE_SUPERMAVEN')
    local use_supermaven = enable_supermaven == '1' or enable_supermaven == 'yes' or enable_supermaven == 'true'
    return use_supermaven
  end
}
