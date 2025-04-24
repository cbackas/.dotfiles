vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(ev)
    vim.keymap.set('n', 'gra', require('fastaction').code_action, { buffer = ev.buf, desc = 'Code Actions' })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', '<leader>tih', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end,
      { desc = "[T]oggle [I]nlay [H]ints" })
  end,
})

vim.lsp.inlay_hint.enable(true)
vim.lsp.config('*', {
  capabilities = vim.tbl_deep_extend("force",
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities(),
    {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
        semanticTokens = {
          multilineTokenSupport = true
        }
      }
    }
  )
})
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
    },
  }
})
vim.lsp.config("denols", {
  workspace_required = true,
  settings = {
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
  }
})
vim.lsp.config("vtsls", {
  workspace_required = true,
  settings = {
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
    vtsls = {
      experimental = {
        maxInlayHintLength = 30
      }
    }
  }
})
vim.lsp.config("yamlls", {
  filetypes = { 'cfn-yaml', 'group_vars', 'workflow' },
  settings = {
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
  }
})
vim.lsp.config("harper_ls", {
  settings = {
    ["harper-ls"] = {
      userDictPath = "/Users/zac/.config/nvim/spell/en.utf-8.add",
      linters = {
        ToDoHyphen = false,
        SentenceCapitalization = false,
      },
      isolateEnglish = true,
      markdown = {
        IgnoreLinkTitle = true,
      },
    },
  }
})

vim.lsp.enable({
  "lua_ls",
  "rust_analyzer",
  "vtsls",
  "denols",
  "eslint",
  "harper_ls",
  "yamlls",
  "pyright",
  "biome",
  "html",
  "dockerls",
  "prismals",
  "cfn_lsp",
  "ansiblels",
  "jdtls",
  "gopls",
  "csharp_ls",
  "bicep",
  "jsonls",
  "astro",
  "tailwindcss"
})
