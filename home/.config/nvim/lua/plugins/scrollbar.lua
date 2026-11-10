return {
  "petertriho/nvim-scrollbar",
  branch = "refactor/v2", -- drop after 2026-11-16 when v2 lands on main
  opts = {
    scrollbar = {
      thumb = {
        blend = 50,
        highlight = { bg = "#F0F0F0" },
      },
      layout = {
        columns = { { "thumb", "marks" } }, -- drop "track" -> no dark background bar
      },
    },
  },
}
