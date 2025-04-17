return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  ---@param opts snacks.Config
  opts = function(_, opts)
    opts.picker = {
      matcher = {
        frecency = true
      },
      layout = {
        reverse = false,
        layout = {
          box = "horizontal",
          backdrop = false,
          width = 0.90,
          height = 0.85,
          border = "none",
          {
            box = "vertical",
            { win = "input", height = 1,          border = "rounded",   title = "{source} {live}", title_pos = "center" },
            { win = "list",  title = " Results ", title_pos = "center", border = "rounded" },
          },
          {
            win = "preview",
            width = 0.60,
            border = "rounded",
            title = " Preview ",
            title_pos = "center",
          },
        }
      },
    }
  end,
  keys = {
    { "<leader>sf", function() Snacks.picker.files({ hidden = true }) end,                   desc = "Find Files" },
    { "<leader>so", function() Snacks.picker.files({ search = vim.fn.expand("%:t:r") }) end, desc = "Find Files" },
    { "<leader>sg", function() Snacks.picker.grep({ hidden = true }) end,                    desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word({ hidden = true }) end,               desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>fb", function() Snacks.picker.buffers({ hidden = true }) end,                 desc = "Buffers" },
    { "<leader>sd", function() Snacks.picker.diagnostics({ hidden = true }) end,             desc = "Diagnostics" },
    { "<leader>sc", function() Snacks.picker.command_history() end,                          desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end,                                 desc = "Commands" },
    { "<leader>sh", function() Snacks.picker.help() end,                                     desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end,                               desc = "Highlights" },
    { "<leader>s?", function() Snacks.picker.recent({ hidden = true }) end,                  desc = "Recent" },
    { "<leader>gr", function() Snacks.picker.lsp_references({ hidden = true }) end,          desc = "LSP References" },
  },
  init = function()
    -- Open find_files picker if no arguments are passed to nvim
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = vim.schedule_wrap(function()
        if vim.v.argv[3] == '-c' then
          return
        end

        if vim.fn.argv(0) == "" then
          require("oil").open(nil, nil, function()
            require("snacks").picker.files({ hidden = true })
          end)
        end
      end),
    })
  end
}
