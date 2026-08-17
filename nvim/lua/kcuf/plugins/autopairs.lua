
-- AUTOPAIRS PLUGIN
-- Questo plugin di syntax-parsing chiude automaticamente parentesi, apici e virgolette

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter", -- Carica il plugin solo quando entri in modalità inserimento
  config = function()
    local autopairs = require("nvim-autopairs")
    
    -- Questa è la configurazione di default che fa esattamente quello che chiedi.
    -- Le opzioni extra sono disabilitate di default.
    autopairs.setup({
      -- Non aggiungere altre opzioni qui se vuoi solo la funzionalità base.
      -- `check_ts = true` è utile ma lo disabilitiamo per massima semplicità.
      check_ts = false,
      -- Disabilitiamo anche le altre funzionalità avanzate per essere sicuri.
      enable_check_bracket_line = false,
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt" , "vim" },
    })
  end,
}
