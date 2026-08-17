
-- TREESITTER PLUGIN
-- Questo plugin integra il motore Tree-sitter in Neovim per fornire analisi sintattica 
-- avanzata e parsing strutturato del codice sorgente. Consente evidenziazione sintattica 
-- accurata, selezione semantica di blocchi logici, movimenti intelligenti nel codice, folding 
-- strutturato e supporto per text objects basati sulla grammatica del linguaggio, anziché su 
-- semplici espressioni regolari. Funziona per decine di linguaggi ed è estensibile con moduli 
-- aggiuntivi per refactoring e navigazione del codice.

return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
        disable = {
          "prolog"
        },
      },
      -- enable indentation
      indent = { 
        enable = true, 
        disable = { "prolog" },
      },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
        "javascript",
        "typescript",
        "toml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "c",
        "java",
        "prolog",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
