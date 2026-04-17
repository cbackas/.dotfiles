return {
  "echasnovski/mini.comment",
  lazy = false,
  config = function()
    require("mini.comment").setup({
      options = {
        -- Function to compute custom 'commentstring' (optional)
        custom_commentstring = nil,

        -- Whether to ignore blank lines in actions and textobject
        ignore_blank_line = false,

        -- Whether to recognize as comment only lines without indent
        start_of_line = false,

        -- Whether to force single space inner padding for comment parts
        pad_comment_parts = true,
      },

      mappings = {
        -- Default mappings for commenting
        comment = "gc",
        comment_line = "gcc",
        comment_visual = "gc",
        textobject = "gc",
      },

      hooks = {
        -- Hooks that run pre and post commenting actions
        pre = function() end,
        post = function() end,
      },
    })
  end,
}
