
-- AUTO SESSION PLUGIN
-- Questo plugin gestisce automaticamente le sessioni di lavoro: salva e ripristina l'intero 
-- stato dell'istanza corrente di neovim, precisamente salva:
--  1) Buffer aperti
--  2) Directory in uso
--  3) Tabbing, finestre e layout
--  4) Stasto dei plugin

return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/downloads", "~/docs" },
    })

    -- HOTKEYS 
    local keymap = vim.keymap -- una variabile che permette di accedere a vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
  end,
}
