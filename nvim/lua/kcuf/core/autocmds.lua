
-- lua/core/autocmds.lua
-- Forza il filetype corretto per Prolog
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.pl" },
  callback = function()
    vim.cmd.setf('prolog')
  end,
})

-- Crea un'automazione che definisce un'hotkey solo quando si apre un file 
-- 'markdown' o '.md'
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  desc = "Setup keymaps for Markdown files",
  callback = function(args)
    vim.keymap.set("n", "<leader>md", function()
      -- 1. Controlla se 'pandoc' è installato
      if vim.fn.executable("pandoc") == 0 then
        vim.notify("Pandoc not found. Please install it (`sudo dnf install pandoc`)", vim.log.levels.ERROR)
        return
      end

      -- 2. Definisci i percorsi dei file
      local source_file = vim.fn.expand("%:p") 
      local source_basename = vim.fn.expand("%:t:r")
      local temp_file = "/tmp/" .. source_basename .. ".html"

      -- 3. Usa pandoc per convertire Markdown in un file HTML temporaneo
      vim.notify("Converting " .. source_file .. " to HTML...")
      local cmd = {"pandoc", "-s", "-o", temp_file, source_file}
      vim.fn.system(cmd) -- usiamo system() perché è un'operazione bloccante e veloce

      -- 4. Apri il file HTML generato con xdg-open
      vim.fn.jobstart({"xdg-open", temp_file}, { detach = true })
      vim.notify("Opening temporary preview in browser: " .. temp_file, vim.log.levels.INFO)
    end, {
      buffer = args.buf,
      silent = true,
      desc = "Convert Markdown to HTML and preview in browser",
    })
  end,
})

