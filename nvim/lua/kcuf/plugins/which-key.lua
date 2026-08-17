
-- WHICH PLUGIN
-- Questo plugin permette di accere alla descrizione (field {desc = ...}) di ogni hotkey
-- default o custom inserita alla configurazione. In questa configurazione si trovano in:
--  1) keymaps.lua 
--  2) nvim-tree.lua

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- configurazione custom
  },
}
