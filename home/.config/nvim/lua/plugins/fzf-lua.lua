local function init()
  local fzf = require('fzf-lua')

  -- fzf as the default ui selector (code actions, etc.)
  fzf.register_ui_select(function(_, items)
    local min_h, max_h = 0.15, 0.70
    local h = (#items + 4) / vim.o.lines
    if h < min_h then
      h = min_h
    elseif h > max_h then
      h = max_h
    end
    return { winopts = { height = h, width = 0.60, row = 0.40 } }
  end)

  local map = vim.keymap.set
  map('n', '<leader>sf', fzf.files, { desc = 'Find Files' })
  map('n', '<leader>so', function()
    fzf.files({ query = vim.fn.expand("%:t:r") })
  end, { desc = 'Find Files (like current)' })
  map('n', '<leader>sg', fzf.live_grep, { desc = 'Grep' })
  map('n', '<leader>sw', fzf.grep_cword, { desc = 'Grep word' })
  map('x', '<leader>sw', fzf.grep_visual, { desc = 'Grep selection' })
  map('n', '<leader>fb', fzf.buffers, { desc = 'Buffers' })
  map('n', '<leader>sd', fzf.diagnostics_workspace, { desc = 'Diagnostics' })
  map('n', '<leader>sc', fzf.command_history, { desc = 'Command History' })
  map('n', '<leader>sC', fzf.commands, { desc = 'Commands' })
  map('n', '<leader>sh', fzf.help_tags, { desc = 'Help Pages' })
  map('n', '<leader>sH', fzf.highlights, { desc = 'Highlights' })
  map('n', '<leader>s?', fzf.oldfiles, { desc = 'Recent' })
  map('n', '<leader>gr', fzf.lsp_references, { desc = 'LSP References' })
end

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = init,
  opts = {
    keymap = {
      fzf = {
        ["ctrl-q"] = "select-all+accept", -- select all -> quickfix
      },
    },
    winopts = {
      height   = 0.85,
      width    = 0.90,
      row      = 0.35,
      col      = 0.55,
      border   = "rounded",
      backdrop = false, -- no dimming behind the window
      preview  = {
        border     = "rounded",
        layout     = "horizontal",
        horizontal = "right:60%",
      },
    },
    fzf_colors = {
      true,
      ["fg"]      = { "fg", "Normal" },
      ["fg+"]     = { "fg", "Normal" },
      ["bg+"]     = { "bg", "CursorLine" },
      ["hl"]      = { "fg", "Special" }, -- match accent (Snacks orange)
      ["hl+"]     = { "fg", "Special" },
      ["query"]   = { "fg", "Normal" },
      ["prompt"]  = { "fg", "Comment" },
      ["pointer"] = { "fg", "Type" },
      ["marker"]  = { "fg", "Type" },
    },
    -- honor .gitignore, show dotfiles, drop .git/.jj and *.test.ts
    files = {
      cwd_prompt = false,
      prompt     = 'fd> ',
      fd_opts    = [[--color=never --type f --type l --exclude .git --exclude .jj --exclude '*.test.ts']],
    },
    -- --hidden to search dotfolders; match color baked into rg output below
    grep = {
      prompt = 'rg> ',
      rg_opts = table.concat({
        "--column --line-number --no-heading --color=always --smart-case --max-columns=4096",
        "--hidden -g '!.git' -g '!.jj' -g '!*.test.ts'",
        "--colors 'path:fg:176,178,191'",
        "--colors 'line:fg:110,118,129'",
        "--colors 'column:fg:110,118,129'",
        "--colors 'match:fg:215,186,125'", -- #D7BA7D (Snacks match orange)
        "--colors 'match:style:bold'",
        "-e",
      }, " "),
      file_ignore_patterns = { ".-package%-lock%.json$", "Cargo%.lock$", ".-LICENSE$" },
    },
  },
}
