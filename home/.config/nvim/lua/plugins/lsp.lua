-- Enable the following language servers
local servers = {
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
  astro = {},
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
  jdtls = {},
  gopls = {}
}

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- normal mode keymap helper func
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

  -- Enable inlay hints if possible
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end

local init = function()
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

  -- custom setup for cloudformation lsp since its so special
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

  -- nvim-lint adds more linters to the built in LSP
  require('lint').linters_by_ft = {
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
    html = { 'eslint_d' },
    ['jinja.html'] = { 'djlint' },
    htmldjango = { 'djlint' },
    yaml = { 'actionlint' },
    sh = { 'shellcheck' },
    json = { 'jsonlint' },
    jsonc = { 'jsonlint' },
  }

  -- auto lint on read/write of buffers so diagnostics are always up to date
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })

  -- conform is for formaters that aren't built into an LSP
  require('conform').setup({
    formatters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      html = { 'eslint_d' },
      ['jinja.html'] = { 'djlint' },
      htmldjango = { 'djlint' },
      ['cfn-yaml'] = { 'yamlfmt' },
      sh = { 'shellcheck', 'shfmt' },
      json = { 'jsonlint' },
      jsonc = { 'jsonlint' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end

local M = {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim',       opts = {} },

    'mfussenegger/nvim-lint',
    {
      'stevearc/conform.nvim',
      event = { 'BufRead', 'BufNewFile' },
      opts = {},
    },
  },
  init = init
}


return { M }
