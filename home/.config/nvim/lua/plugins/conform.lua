return {
  'stevearc/conform.nvim',
  event = { 'BufRead', 'BufNewFile' },
  opts = {
    formatters_by_ft = {
      javascript = { 'eslint' },
      typescript = { 'eslint' },
      -- html = { 'eslint_d' },
      ['jinja.html'] = { 'djlint' },
      htmldjango = { 'djlint' },
      -- ['cfn-yaml'] = { 'yamlfmt' },
      sh = { 'shellcheck', 'shfmt' },
      http = { "kulala" },
    },
    formatters = {
      kulala = {
        command = "kulala-fmt",
        args = { "format", "$FILENAME" },
        stdin = false,
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  }
}
