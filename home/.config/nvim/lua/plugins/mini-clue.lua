return {
  'echasnovski/mini.clue',
  version = '*',
  event = "VeryLazy",
  config = function()
    local miniclue = require('mini.clue')

    miniclue.setup {
      window = {
        config = { anchor = 'SE', width = '60' },
        delay = 200,
        -- Keys to scroll inside the clue window
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
      },
      clues = {
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.z(),
        { mode = 'n', keys = '<Leader>t', desc = '+[T]rouble' },
        { mode = 'n', keys = '<Leader>s', desc = '+[S]earch (Telescope)' },
        { mode = 'n', keys = '<Leader>r', desc = '+[R]eplace' },
        { mode = 'n', keys = '<Leader>b', desc = '+[B]uffers' },
        { mode = 'n', keys = '<Leader>g', desc = '+[G]oto' },
        { mode = 'n', keys = '<Leader>c', desc = '+[C]ode' },
        { mode = 'n', keys = '<Leader>h', desc = '+[H]arpoon' },
        { mode = 'n', keys = '<Leader>p', desc = '+[P]review' },
      },
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Leader triggers
        { mode = 'n', keys = '<M>' },
        { mode = 'x', keys = '<M>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
      },
    }
  end,
}
