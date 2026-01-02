-- ~/.config/nvim/lua/plugins/formatter.lua
-- Auto-formateo al guardar con conform.nvim

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    -- Formatters por tipo de archivo
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
    },

    -- Configuración de Prettier con 4 espacios
    formatters = {
      prettier = {
        prepend_args = {
          "--tab-width",
          "4",
          "--single-attribute-per-line",
          "false",
          "--html-whitespace-sensitivity",
          "css",
          "--print-width",
          "150",
        },
      },
    },

    -- Formatear automáticamente DESPUÉS de guardar (asíncrono, no bloquea la UI)
    format_after_save = {
      lsp_fallback = true,
    },

    -- Notificar cuando un formateador no está disponible
    notify_on_error = true,
  },
}
