-- ~/.config/nvim/lua/plugins/themes.lua
-- Temas de colores

return {
  -- Catppuccin: Tema pastel suave con múltiples variantes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        telescope = true,
        which_key = true,
      },
    },
  },

  -- Kanagawa: Tema inspirado en colores japoneses
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      theme = "dragon", -- wave, dragon, lotus
      background = {
        dark = "dragon",
        light = "lotus",
      },
    },
  },

  -- Oh-Lucy: Tema con colores vibrantes
  {
    "Yazeed1s/oh-lucy.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Tema adicional recomendado: Tokyo Night
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- storm, moon, night
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
  },
}
