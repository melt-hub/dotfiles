
-- VIM MAXIMIZER PLUGIN
-- Questo plugin permette di massimizzare la visualizzazione della finestra in uso temporaneamente

return {
  "szw/vim-maximizer",
  keys = {
    { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
  },
}
