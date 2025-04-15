return {
  "https://gitlab.com/cbackas/sonarlint.nvim.git",
  opts = {
    server = {
      cmd = {
        vim.fn.expand("~/.local/share/nvim/mason/packages/sonarlint-language-server/sonarlint-language-server"),
        '-stdio',
        '-analyzers',
        vim.fn.expand("~/.local/share/nvim/mason/share/sonarlint-analyzers/sonarjs.jar"),
      },
    },
    filetypes = {
      "typescript",
      "javascript"
    }
  },
  cond = function()
    -- if 'USE_SONARLINT' env var isn't true, don't load the plugin
    local use_sonarlint = os.getenv('USE_SONARLINT')
    return use_sonarlint == '1' or use_sonarlint == 'yes' or use_sonarlint == 'true'
  end
}
