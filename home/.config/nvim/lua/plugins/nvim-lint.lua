return {
  'mfussenegger/nvim-lint',
  config = function()
    require('lint').linters_by_ft = {
      -- javascript = { 'eslint' },
      -- typescript = { 'eslint' },
      -- html = { 'eslint_d' },
      groovy = { 'npm-groovy-lint' },
      Jenkinsfile = { 'npm-groovy-lint' },
      ['jinja.html'] = { 'djlint' },
      htmldjango = { 'djlint' },
      workflow = { 'actionlint' },
      sh = { 'shellcheck' },
      -- json = { 'jsonlint' },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
