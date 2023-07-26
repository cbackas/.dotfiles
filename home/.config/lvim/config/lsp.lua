-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>A

-- --- disable automatic installation of servers
lvim.lsp.installer.setup.automatic_servers_installation = true

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return (server ~= "ansiblels") and (server ~= "azurepipelines")
end, lvim.lsp.automatic_configuration.skipped_servers)

require 'lspconfig'.yamlls.setup {
  cmd = { "/Users/zac/.local/share/lvim/mason/bin/yaml-language-server", "--stdio" },
  -- on_attach = require'lsp'.common_on_attach,
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      hover = true,
      completion = true,

      customTags = {
        "!fn",
        "!And",
        "!If",
        "!Not",
        "!Equals",
        "!Or",
        "!FindInMap sequence",
        "!Base64",
        "!Cidr",
        "!Ref",
        "!Ref Scalar",
        "!Sub",
        "!GetAtt",
        "!GetAZs",
        "!ImportValue",
        "!Select",
        "!Split",
        "!Join sequence"
      },
    },
  },
}

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   enda
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- linters, formatters and code actions <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    exe = "eslint_d",
    disagnostic_config = { virtual_text = false, },
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
  },
}
-- formatters.setup {
--   { command = "stylua" },
--   {
--     command = "prettier",
--     extra_args = { "--print-width", "100" },
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  {
    command = "shellcheck",
    args = { "--severity", "warning" },
  },
  {
    exe = "eslint_d",
    disagnostic_config = { virtual_text = false, },
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
  },
  {
    exe = "cfn-lint",
    filetypes = { "yaml" }
  }
}
local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    exe = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
  },
}

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = vim.fn.expand("~/.config/tmux/plugins.conf"),
  command = "setfiletype tmux",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = vim.fn.expand("~/.config/tmux/keybinds.conf"),
  command = "setfiletype tmux",
})
