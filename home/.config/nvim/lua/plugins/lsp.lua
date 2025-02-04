-- Enable the following language servers
local servers = {
  pyright = {},
  rust_analyzer = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
    },
  },
  denols = {
    root_dir = function(fname) require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")(fname) end,
    deno = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      }
    }
  },
  vtsls = {
    typescript = {
      format = {
        enable = false
      },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      }
    },
  },
  -- tsserver = {
  --   -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
  --   javascript = {
  --     inlayHints = {
  --       includeInlayEnumMemberValueHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayParameterNameHints = 'all',
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayVariableTypeHints = true,
  --     },
  --   },
  --   typescript = {
  --     inlayHints = {
  --       includeInlayEnumMemberValueHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayParameterNameHints = 'all',
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayVariableTypeHints = true,
  --     },
  --   },
  -- },
  eslint = {},
  biome = {},
  astro = {},
  html = { filetypes = { 'html' } },
  dockerls = { filetypes = { 'Dockerfile', 'dockerfile' } },
  prismals = {},
  lua_ls = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
  yamlls = {
    filetypes = { 'yaml', 'cfn-yaml', 'group_vars', 'workflow' },
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
        "!GetAZs sequence",
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
  ansiblels = {},
  jdtls = {},
  gopls = {},
  csharp_ls = {},
  bicep = {},
}

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  if require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
    -- check if client name is in a list
    local clients_to_stop = { "tsserver", "vtsls", "eslint", "eslint_d" }
    if vim.tbl_contains(clients_to_stop, client.name) then
      -- stop the client
      client.stop()
      return
    end
  end

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
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Enable inlay hints if possible
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
    nmap('<leader>tih', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
      '[T]oggle [I]nlay [H]int')
  end
end

local init = function()
  ---@type lsp.ClientCapabilities
  local capabilities = vim.tbl_deep_extend("force",
    vim.lsp.protocol.make_client_capabilities(),
    require('blink.cmp').get_lsp_capabilities()
  )
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  local ensure_installed = vim.tbl_keys(servers)
  -- don't try to install csharp_ls if dotnet isn't installed
  if not vim.fn.executable('dotnet') then
    ensure_installed['csharp_ls'] = nil
  end

  if os.getenv("USE_SONARLINT") == "true" then
    vim.tbl_extend('keep', ensure_installed, { 'sonarlint-language-server' })
  end

  mason_lspconfig.setup {
    ensure_installed
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
        root_dir = servers[server_name].root_dir,
      }
    end
  }

  -- custom setup for cloudformation lsp since its so special
  require('lspconfig.configs').cfn_lsp = {
    default_config = {
      cmd = { os.getenv("HOME") .. '/.local/bin/cfn-lsp-extra' },
      filetypes = { 'cfn-yaml' },
      root_dir = function(fname)
        return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]) or vim.fn.getcwd()
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
    -- javascript = { 'eslint' },
    -- typescript = { 'eslint' },
    -- html = { 'eslint_d' },
    groovy = { 'npm-groovy-lint' },
    Jenkinsfile = { 'npm-groovy-lint' },
    ['jinja.html'] = { 'djlint' },
    htmldjango = { 'djlint' },
    workflow = { 'actionlint' },
    sh = { 'shellcheck' },
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
      javascript = { 'eslint' },
      typescript = { 'eslint' },
      -- html = { 'eslint_d' },
      ['jinja.html'] = { 'djlint' },
      htmldjango = { 'djlint' },
      -- ['cfn-yaml'] = { 'yamlfmt' },
      sh = { 'shellcheck', 'shfmt' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end

return {
  'neovim/nvim-lspconfig',
  init = init,
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = 'lua',
      dependencies = {
        -- TODO switch back to gonstoll/wezterm-types after PR merged
        { 'cbackas/wezterm-types', lazy = true },
      },
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = 'wezterm-types',      mods = { 'wezterm' } },
          { path = 'snacks.nvim',        words = { "snacks", "Snacks" } },
        },
      },
    },
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
    'saghen/blink.cmp',
    {
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
  }
}
