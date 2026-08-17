
-- una variabile che permette di accedere all'oggetto vim.keymap
local keymap = vim.keymap

-- COMMAND KEY
vim.g.mapleader = " "

-- HOTKEYS
-- (la sintassi è: vim.keymap.set("mode" "hotkey" "azione" {tabella di opzioni}), qui uso: 
-- {desc} = "Cosa fa l'hotkey" per usarlo col plugin Which)
keymap.set("i", "jk", "<ESC>", {desc = "Esci dalla insert mode con jk"})
keymap.set("n", "<leader>nh", ":nohl<CR>", {desc = "Pulisci highlights delle ricerche"})

keymap.set("n","<leader>+","<C-a>", {desc = "Incrementa numero"})
keymap.set("n","<leader>-","<C-x>", {desc = "Decrementa numero"})

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", {desc = "Splitta verticalmente"})
keymap.set("n", "<leader>sh", "<C-w>s", {desc = "Splitta orizzontalmente"})
keymap.set("n", "<leader>se", "<C-w>=", {desc = "Bilancia dimensioni finestre"})
keymap.set("n", "<leader>sx", "<cmd>close<CR>", {desc = "Chiudi finestra in uso"})

-- tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", {desc = "Apri nuova tab"})
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", {desc = "Chiudi tab in uso"})
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", {desc = "Prossima tab"})
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", {desc = "Tab precedente"})
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", {desc = "Apri buffer in corso in una nuova tab"})
