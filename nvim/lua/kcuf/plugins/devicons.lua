
return {
  "nvim-tree/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").setup({
      override = {
        pl = {
          icon = "\u{e7a1}",
          color = "#ead2ac",
          cterm_color = "185",
          name = "Prolog",
        },
        lisp = {
          icon = "\u{e6b0}"
        }
      },
    })
  end,
}
