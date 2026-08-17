return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = 'nightfox',
        
        component_separators = { left = ' ', right = ' '},
        section_separators= { left = '', right = ''},

        icons_enabled = true,
      },

      sections = {
        lualine_a = {'mode'},
        lualine_b = {'filename'},
        lualine_c = {'branch', 'diff'},

        lualine_x = {'diagnostics', 'filetype'},
        lualine_y = {'location'},
        lualine_z = {{'datetime', style = '%I:%M %p'}}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', path = 1}},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      extensions = {}
    })
  end,
}
