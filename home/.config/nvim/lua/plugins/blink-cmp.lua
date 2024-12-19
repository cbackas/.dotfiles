return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  -- TODO switch back to a tag after its stable-ish
  -- version = 'v0.*.*',
  branch = 'main',
  build = 'cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<C-CR>'] = { 'select_and_accept' },
      ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- experimental signature help support
    signature = { enabled = true }
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" }
}
