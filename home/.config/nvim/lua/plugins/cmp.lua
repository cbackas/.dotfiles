local config = function()
  local cmp = require 'cmp'

  local lspkind = require('lspkind')

  cmp.setup {
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
      end
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete {},
      ['<C-CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    },
    sources = {
      { name = 'nvim_lsp', keyword_length = 2 },
      { name = 'path',     keyword_length = 2 },
    },
    formatting = {
      format = lspkind.cmp_format {
        with_text = true,
        menu = {
          buffer = "[buf]",
          nvim_lsp = "[LSP]",
          path = "[path]",
          luasnip = "[snip]",
          gh_issues = "[issues]",
          cody = "[cody]",
        },
      },
    },
  }

  -- autocomplete for finding in file
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- autocomplete for vim commands
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { 'Man', '!' }
        }
      }
    })
  })
end

return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Adds LSP completion
    'hrsh7th/cmp-nvim-lsp',
    -- Adds path completion
    'hrsh7th/cmp-path',
    -- Adds buffer completion
    'hrsh7th/cmp-buffer',

    -- command line completion
    'hrsh7th/cmp-cmdline',

    -- formatting for the cmp menu
    'onsails/lspkind.nvim',
  },
  config = config,
  init = function()
    local cmp = require('cmp')
    -- hide copilot suggestions while cmp menu is open
    -- cmp.event:on("menu_opened", function()
    --   vim.b.copilot_suggestion_hidden = true
    -- end)
    -- cmp.event:on("menu_closed", function()
    --   vim.b.copilot_suggestion_hidden = false
    -- end)
  end,
}
