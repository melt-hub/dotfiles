
-- una variabile che permette di accedere al path ~/.local/share/nvim/lazy/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- se la directory lazy non esiste, la crea
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",                     
    "https://github.com/folke/lazy.nvim.git", -- clona la repo di lazy  
    "--branch=stable",                        -- scrive nella path designata
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)                 -- usa il path designato per caricare lazy.nvim

-- la directory da dove caricare i plugin
require("lazy").setup("kcuf.plugins", {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
