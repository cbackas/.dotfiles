-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap('<leader>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   vim.lsp.buf.format()
  --   -- Re-enable diagnostics, following this:
  --   -- https://www.reddit.com/r/neovim/comments/15dfx4g/help_lsp_diagnostics_are_not_being_displayed/?utm_source=share&utm_medium=web2x&context=3
  --   vim.diagnostic.enable(0)
  -- end, { desc = 'Format current buffer with LSP' })

  -- Enable inlay hints if possible
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint(bufnr, true)
  end
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {},
  rust_analyzer = {},
  tsserver = {
    -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
    javascript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    typescript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
  html = { filetypes = { 'html' } },
  dockerls = { filetypes = { 'Dockerfile', 'dockerfile' } },
  prismals = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
  yamlls = {
    filetypes = { 'yaml', 'cfn-yaml', 'group_vars' },
    yaml = {
      format = {
        enable = false,
      },
      hover = true,
      completion = true,
      customTags = {
        "!Base64 scalar",
        "!Cidr scalar",
        "!And sequence",
        "!Equals sequence",
        "!If sequence",
        "!Not sequence",
        "!Or sequence",
        "!Condition scalar",
        "!FindInMap sequence",
        "!GetAtt scalar",
        "!GetAtt sequence",
        "!GetAZs scalar",
        "!ImportValue scalar",
        "!Join sequence",
        "!Select sequence",
        "!Split sequence",
        "!Sub scalar",
        "!Sub sequence",
        "!Transform mapping",
        "!Ref scalar",
      },
    },
  },
  groovyls = {
    filetypes = { 'groovy', 'Jenkinsfile' }
  },
  jdtls = {}
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local lsp = require('lspconfig')[server_name]
    if not servers[server_name] then
      return
    end
    lsp.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = servers[server_name].filetypes,
    }
  end
}

require('lspconfig.configs').cfn_lsp = {
  default_config = {
    cmd = { os.getenv("HOME") .. '/.local/bin/cfn-lsp-extra' },
    filetypes = { 'cfn-yaml' },
    root_dir = function(fname)
      return require('lspconfig').util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
    settings = {
      documentFormatting = false,
    },
  },
}
require('lspconfig').cfn_lsp.setup {
  on_attach = on_attach
}

require('lint').linters_by_ft = {
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  html = { 'djlint' },
  ['jinja.html'] = { 'djlint' },
  htmldjango = { 'djlint' },
  yaml = { 'actionlint' },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

require('conform').setup({
  formatters_by_ft = {
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
    html = { 'djlint' },
    ['jinja.html'] = { 'djlint' },
    htmldjango = { 'djlint' },
    ['cfn-yaml'] = { 'yamlfmt' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
