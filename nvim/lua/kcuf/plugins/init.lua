
-- lua/kcuf/plugins/init.lua
return {
  -- Plugin base necessari
  "nvim-lua/plenary.nvim", 
  "christoomey/vim-tmux-navigator",
  
  require("kcuf.plugins.colorscheme"),
  -- require("kcuf.plugins.alpha"),
  require("kcuf.plugins.autopairs"),
  require("kcuf.plugins.auto-session"),
  -- require("kcuf.plugins.bufferline"),
  require("kcuf.plugins.lualine"),
  require("kcuf.plugins.nvim-tree"),
  require("kcuf.plugins.telescope"),
  require("kcuf.plugins.treesitter"),
  require("kcuf.plugins.maximizer"),
  require("kcuf.plugins.which-key"),
  require("kcuf.plugins.prolog"),
  require("kcuf.plugins.devicons"),
}
