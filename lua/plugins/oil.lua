return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- opcional, para iconos
  config = function()
    require("oil").setup({
      -- Configuración por defecto
      default_file_explorer = true,
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      -- Eliminar archivos a la papelera en lugar de borrarlos permanentemente
      delete_to_trash = true,
      -- No mostrar archivos ocultos por defecto
      skip_confirm_for_simple_edits = false,
      view_options = {
        show_hidden = false,
      },
      keymaps = {
        ["<C-c>"] = "actions.close",
        ["g."] = "actions.toggle_hidden",  -- Toggle archivos ocultos con g.
      }
    })

    -- Atajo de teclado: presiona "-" para abrir el directorio padre
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Abrir directorio padre" })
  end,
}
