return {
  
  --==================| GRUVBOX |==================--  
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "", -- "hard", "soft" o ""
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },

  --==================| GRUVBOX MATERIAL |==================--  
  {
    "sainnhe/gruvbox-material",
    lazy = true, 
    config = function()
      vim.g.gruvbox_material_background = 'medium'
      vim.g.gruvbox_material_foreground = 'material'
      vim.g.gruvbox_material_disable_italic_comment = 0
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_diagnostic_text_highlight = 1
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
      vim.g.gruvbox_material_current_word = 'grey background'
      vim.g.gruvbox_material_statusline_style = 'default'
      vim.g.gruvbox_material_better_performance = 1
      -- vim.cmd("colorscheme gruvbox-material")
    end,
  },

  --==================| GRUVBOX BABY |==================--  
  {
    "luisiacc/gruvbox-baby",
    lazy = true, 
    config = function()
      vim.g.gruvbox_baby_function_style = "NONE"
      vim.g.gruvbox_baby_keyword_style = "italic"
      vim.g.gruvbox_baby_comment_style = "italic"
      vim.g.gruvbox_baby_string_style = "italic"
      vim.g.gruvbox_baby_variable_style = "NONE"
      vim.g.gruvbox_baby_highlights = {["@lsp.type.namespace"] = {fg = "#bbdaff"}}
      vim.g.gruvbox_baby_color_overrides = {}
      vim.g.gruvbox_baby_telescope_theme = 1
      vim.g.gruvbox_baby_transparent_mode = 1
      vim.g.gruvbox_baby_background_color = "medium"
      -- vim.cmd("colorscheme gruvbox-baby")
    end,
  },

  --==================| KANAGAWA |==================--  
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true},
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} }
        },
        overrides = function(colors)
          return {}
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
      -- vim.cmd("colorscheme kanagawa-wave")
    end,
  },

  --==================| ROSE PINE |==================--  
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true, 
    config = function()
      require("rose-pine").setup({
        variant = "auto",
        dark_variant = "main",
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,
        groups = {
          background = "base",
          background_nc = "_experimental_nc",
          panel = "surface",
          panel_nc = "base",
          border = "highlight_med",
          comment = "muted",
          link = "iris",
          punctuation = "subtle",
          error = "love",
          hint = "iris",
          info = "foam",
          warn = "gold",
          headings = {
            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
          }
        },
        highlight_groups = {}
      })
      -- vim.cmd("colorscheme rose-pine")
    end,
  },

  --==================| EVERFOREST |==================--  
  {
    "sainnhe/everforest",
    lazy = true,
    config = function()
      vim.g.everforest_background = 'medium'
      vim.g.everforest_better_performance = 1
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comment = 0
      vim.g.everforest_diagnostic_text_highlight = 1
      vim.g.everforest_diagnostic_line_highlight = 1
      vim.g.everforest_diagnostic_virtual_text = 'colored'
      vim.g.everforest_current_word = 'grey background'
      vim.g.everforest_ui_contrast = 'low'
      -- vim.cmd("colorscheme everforest")
    end,
  },

  --==================| TOKYO NIGHT |==================--  
  {
    "folke/tokyonight.nvim",
    lazy = true, 
    config = function()
      require("tokyonight").setup({
        style = "night",
        light_style = "day",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      })
      -- vim.cmd("colorscheme tokyonight")
    end,
  },

  --==================| MONOKAI |==================--  
  {
    "loctvl842/monokai-pro.nvim",
    lazy = true, 
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
        terminal_colors = true,
        devicons = true,
        styles = {
          comment = { italic = true },
          keyword = { italic = true },
          type = { italic = true },
          storageclass = { italic = true },
          structure = { italic = true },
          parameter = { italic = true },
          annotation = { italic = true },
          tag_attribute = { italic = true },
        },
        filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
        inc_search = "background",
        background_clear = {
          "float_win",
          "toggleterm",
          "telescope",
          "which-key",
          "renamer",
          "notify",
          "nvim-tree",
          "neo-tree",
          "bufferline",
        },
      })
      -- vim.cmd("colorscheme monokai-pro")
    end,
  },

  --==================| FLOW |==================--  
  {
    "0xstepit/flow.nvim",
    lazy = true, 
    config = function()
      require("flow").setup({
        transparent = true,
        fluo_color = "pink",
        mode = "normal", -- normal | bright | desaturate | dark
        aggressive_spell = false,
      })
      -- vim.cmd("colorscheme flow")
    end,
  },

  --==================| DRACULA |==================--  
  {
    "Mofiqul/dracula.nvim",
    lazy = true, 
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        colors = {
          bg = "#282A36",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          green = "#50fa7b",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
          bright_red = "#FF6E6E",
          bright_green = "#69FF94",
          bright_yellow = "#FFFFA5",
          bright_blue = "#D6ACFF",
          bright_magenta = "#FF92DF",
          bright_cyan = "#A4FFFF",
          bright_white = "#FFFFFF",
          menu = "#21222C",
          visual = "#3E4452",
          gutter_fg = "#4B5263",
          nontext = "#3B4048",
        },
        show_end_of_buffer = true,
        transparent_bg = true,
        lualine_bg_color = "#44475a",
        italic_comments = true,
      })
      -- vim.cmd("colorscheme dracula")
    end,
  },

  --==================| PALENIGHT |==================--  
  {
    "drewtempelmeyer/palenight.vim",
    lazy = true, 
    config = function()
      vim.g.palenight_terminal_italics = 1
      -- vim.cmd("colorscheme palenight")
    end,
  },

  --==================| MOONFLY |==================--  
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = true, 
    config = function()
      vim.g.moonflyItalics = true
      vim.g.moonflyNormalFloat = true
      vim.g.moonflyTerminalColors = true
      vim.g.moonflyUndercurls = true
      vim.g.moonflyUnderlineMatchParen = true
      vim.g.moonflyVirtualTextColor = true
      -- vim.cmd("colorscheme moonfly")
    end,
  },

  --==================| SONOKAI |==================--  
  {
    "sainnhe/sonokai",
    lazy = true, 
    config = function()
      vim.g.sonokai_style = 'default'
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_disable_italic_comment = 0
      vim.g.sonokai_diagnostic_text_highlight = 1
      vim.g.sonokai_diagnostic_line_highlight = 1
      vim.g.sonokai_diagnostic_virtual_text = 'colored'
      vim.g.sonokai_current_word = 'grey background'
      -- vim.cmd("colorscheme sonokai")
    end,
  },

  --==================| EDGE |==================--  
  {
    "sainnhe/edge",
    lazy = true, 
    config = function()
      vim.g.edge_style = 'default'
      vim.g.edge_better_performance = 1
      vim.g.edge_enable_italic = 1
      vim.g.edge_disable_italic_comment = 0
      vim.g.edge_diagnostic_text_highlight = 1
      vim.g.edge_diagnostic_line_highlight = 1
      vim.g.edge_diagnostic_virtual_text = 'colored'
      vim.g.edge_current_word = 'grey background'
      -- vim.cmd("colorscheme edge")
    end,
  },

  --==================| NORD |==================--  
  {
    "shaunsingh/nord.nvim",
    lazy = true, -- Modificato
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true
      require("nord").set()
      -- vim.cmd("colorscheme nord")
    end,
  },

  --==================| NIGHTFOX |==================--  
  {
    "EdenEast/nightfox.nvim",
    lazy = false, 
    config = function()
      require("nightfox").setup({
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled",
          transparent = true,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          styles = {
            comments = "italic",
            conditionals = "NONE",
            constants = "NONE", 
            functions = "NONE",
            keywords = "bold",
            numbers = "NONE",
            operators = "NONE",
            strings = "italic",
            types = "NONE",
            variables = "NONE",
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })
      vim.cmd("colorscheme nightfox")
    end,
  },

  --==================| ONEDARK |==================--  
  {
    "olimorris/onedarkpro.nvim",
    lazy = true, 
    config = function()
      require("onedarkpro").setup({
        colors = {},
        highlights = {},
        styles = {
          types = "NONE",
          methods = "NONE",
          numbers = "NONE",
          strings = "NONE",
          comments = "italic",
          keywords = "bold,italic",
          constants = "NONE",
          functions = "italic",
          operators = "NONE",
          variables = "NONE",
          parameters = "NONE",
          conditionals = "italic",
          virtual_text = "NONE",
        },
      })
     -- vim.cmd("colorscheme onedark")
    end,
  },

  --==================| GITHUB |==================--  
  {
    "projekt0n/github-nvim-theme",
    lazy = true, 
    config = function()
      require("github-theme").setup({
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/github-theme",
          compile_file_suffix = "_compiled",
          hide_end_of_buffer = true,
          hide_nc_statusline = true,
          transparent = true,
          terminal_colors = true,
          dim_inactive = true,
          module_default = true,
          styles = {
            comments = "italic",
            functions = "NONE",
            keywords = "bold",
            variables = "NONE",
            conditionals = "NONE",
            constants = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })
      -- vim.cmd("colorscheme github_dark_dimmed")
    end,
  },

}
