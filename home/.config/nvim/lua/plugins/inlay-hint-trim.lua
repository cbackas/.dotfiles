return {
  "ray-d-song/inlay-hint-trim.nvim",
  config = function()
    require("inlay-hint-trim").setup({
      max_length = 30,
      ellipsis = "…",
      clients = {
        ["typescript-tools"] = true,
        ["tsserver"] = true,
        ["ts_ls"] = true,
        ["tsgo"] = true,
      },
    })
  end,
}
