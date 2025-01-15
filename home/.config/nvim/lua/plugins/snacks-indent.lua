return {
  "folke/snacks.nvim",
  ---@param opts snacks.Config
  opts = function(_, opts)
    opts.indent = {
      indent = {
        char = '┊',
        only_scope = false,
        only_current = false,
        hl = "SnacksPickerBoxBorder"
      },
      animate = {
        enabled = false
      },
      scope = {
        enabled = true, -- enable highlighting the current scope
        priority = 200,
        char = "│",
        underline = false,   -- underline the start of the scope
        only_current = true, -- only show scope in the current window
        hl = "IndentColor2",
      },
    }

    Snacks.util.set_hl({
      ['1'] = { fg = '#ff9999' },
      ['2'] = { fg = '#ffcb99' },
      ['3'] = { fg = '#feff99' },
      ['4'] = { fg = '#99ff99' },
      ['5'] = { fg = '#9999ff' },
      ['6'] = { fg = '#9e1cff' },
      ['7'] = { fg = '#d36cff' },
      ['8'] = { fg = '#ffacd9' }
    }, { prefix = 'IndentColor', default = true })
  end,
}
