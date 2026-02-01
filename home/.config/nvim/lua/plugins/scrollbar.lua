return {
  "petertriho/nvim-scrollbar",
  event = "BufReadPost",
  opts = {
    show = true,
    show_in_active_only = false,
    set_highlights = true,
    handle = {
      blend = 50,
      color = "#F0F0F0"
    }
  }
}
