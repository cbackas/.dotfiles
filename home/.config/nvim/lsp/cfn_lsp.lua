---@type vim.lsp.Config
return {
  cmd = { os.getenv("HOME") .. '/.local/bin/cfn-lsp-extra' },
  filetypes = { 'cfn-yaml' },
  settings = {
    documentFormatting = false,
  },
}
