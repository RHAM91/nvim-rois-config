-- ~/.config/nvim/lua/plugins/mason.lua
-- Gestor de instalación de LSP servers, formatters y linters

return {
  -- Mason: Gestor de herramientas
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
  },

  -- Mason-tool-installer: Auto-instala herramientas
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        -- Formatters
        "prettier",     -- JS, TS, Vue, CSS, HTML, JSON, etc.
        "stylua",       -- Lua

        -- LSP Servers (ya los tienes configurados manualmente, pero por si acaso)
        "vtsls",        -- TypeScript/JavaScript
        "vue-language-server",
        "html-lsp",
        "css-lsp",
        "emmet-language-server",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}
