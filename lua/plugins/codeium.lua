return {
  "Exafunction/codeium.vim",
  event = "BufEnter",
  config = function()
    -- Deshabilitar los atajos por defecto para evitar conflictos con blink.cmp
    vim.g.codeium_disable_bindings = 1

    -- Habilitar Codeium globalmente
    vim.g.codeium_enabled = true

    -- Control de autocompletado automático (false = manual, true = automático)
    vim.g.codeium_manual = false

    -- Keymaps personalizados para Codeium
    -- Aceptar sugerencia completa con Tab
    vim.keymap.set("i", "<Tab>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true, desc = "Codeium: Accept suggestion" })

    -- Aceptar solo la siguiente palabra
    vim.keymap.set("i", "<C-k>", function()
      return vim.fn["codeium#AcceptNextWord"]()
    end, { expr = true, silent = true, desc = "Codeium: Accept next word" })

    -- Aceptar solo la siguiente línea
    vim.keymap.set("i", "<C-l>", function()
      return vim.fn["codeium#AcceptNextLine"]()
    end, { expr = true, silent = true, desc = "Codeium: Accept next line" })

    -- Navegar entre sugerencias
    vim.keymap.set("i", "<C-;>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true, desc = "Codeium: Next suggestion" })

    vim.keymap.set("i", "<C-,>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true, silent = true, desc = "Codeium: Previous suggestion" })

    -- Limpiar sugerencia actual
    vim.keymap.set("i", "<C-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true, desc = "Codeium: Clear suggestion" })

    -- Nota: <C-Space> eliminado para evitar conflicto con blink.cmp
    -- Codeium funciona en modo automático (codeium_manual = false)
    -- Si necesitas forzar sugerencias, usa <C-;> para ciclar

    -- Abrir Codeium Chat
    vim.keymap.set("n", "<leader>cc", function()
      vim.fn["codeium#Chat"]()
    end, { desc = "Codeium: Open Chat" })
  end,
}
