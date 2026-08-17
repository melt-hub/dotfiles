
vim.opt.clipboard = "unnamedplus"

-- una variabile per chiamare vim.opt semplicement con opt.comando.
-- (l'oggetto vim.opt implementato nel core di neovim (C), decodifica le istruzioni passate
-- in dot-notation e, se implementate, effettua un'opportuna chiamata all'API di neovim, che 
-- ne modifica le variabili ambientali a run-time)
local opt = vim.opt 

-- FILE EXPLORER
vim.cmd("let g:netrw_liststyle = 3") -- imposta la visualizzazione di netrw a 3: visualizzazione ad albero.
-- (netrw è il file explorer di vim/neovim) 

-- NAVIGATION & WORKFLOW 
opt.backspace = "indent,eol,start"   -- fa funzionare backspace in maniera fluida
-- opt.clipboard:append("unnamedplus")  -- mappa il registro locale di neovim nella clipboard


-- COLORSCHEME & VISUALIZATION
opt.cursorline = true     -- evidenzia la posizione del cursore
opt.relativenumber = true -- visualizza la distanza in righe dal cursore.
opt.number = true         -- visualizza il numero di riga.

vim.cmd('colorscheme slate')
opt.termguicolors = true  -- attiva i true-color per il color scheme selezionato, altrimenti visualizzerebbe i colori default del term
opt.background = "dark"   -- imposta il tema su scuro
opt.signcolumn = "yes"    -- riserva una colonna per i simboli di debug/usti dai plugin


-- TABBING & INDENTATION 
opt.tabstop = 2          -- un tab è visualizzato come 2 spazi.
opt.expandtab = true     -- un tab è inserito come 2 caratteri di spazio.
opt.shiftwidth = 2       -- le righe indentate con << e >> vengono indentate di 2 spazi.
opt.autoindent = true    -- autoindenta in base all'indentazione della riga precedente.

opt.wrap = false         -- disattiva il line-wrapping


-- SEARCH SETTINGS
opt.ignorecase = true    -- usando solo minuscole la ricerca non è case-sensitive 
opt.smartcase = true     -- se usi mixed-case la ricerca è case-sensitive


-- WINDOWS
opt.splitright = true    -- splitta verticalmente la finestra a dx
opt.splitbelow = true    -- splitta orizzontalmente la finestra verso il basso



