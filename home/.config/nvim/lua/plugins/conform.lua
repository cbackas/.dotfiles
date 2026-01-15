local function not_vtsls(client)
  return client.name ~= "vtsls" and client.name ~= "vue_ls"
end

local function not_jsonls(client)
  return client.name ~= "jsonls"
end

return {
  'stevearc/conform.nvim',
  event = { 'BufRead', 'BufNewFile' },
  opts = {
    formatters_by_ft = {
      javascript = { 'eslint', lsp_format = 'first', stop_after_first = true, filter = not_vtsls },
      typescript = { 'eslint', lsp_format = 'first', stop_after_first = true, filter = not_vtsls },
      json = { filter = not_jsonls },
      vue = { 'eslint', lsp_format = 'first', stop_after_first = true, filter = not_vtsls },
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
