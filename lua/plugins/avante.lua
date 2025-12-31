-- ~/.config/nvim/lua/plugins/avante.lua
-- Avante.nvim: AI-powered code assistant para ask y edit (sin auto-suggestions)

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Usar la última versión
  build = "make", -- Requiere compilación

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",

    -- Opcional pero recomendado: render markdown
    "MeanderingProgrammer/render-markdown.nvim",

    -- Opcional: soporte para imágenes
    "HakonHarnes/img-clip.nvim",

    -- Opcional: integración con nvim-cmp (blink.cmp ya lo tenemos)
    -- "hrsh7th/nvim-cmp",
  },

  opts = {
    -- ========================================
    -- MODO LEGACY: Sin ejecución automática de herramientas
    -- ========================================
    mode = "legacy",

    -- ========================================
    -- PROVEEDOR: Claude (Anthropic)
    -- ========================================
    provider = "claude",

    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-haiku-20241022", -- Claude Haiku 4.5
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192,
        },
        -- API key configurado vía variable de entorno o directamente aquí
        -- IMPORTANTE: Es mejor usar variable de entorno ANTHROPIC_API_KEY
      },
    },

    -- ========================================
    -- COMPORTAMIENTO: Deshabilitar auto-suggestions
    -- ========================================
    behaviour = {
      auto_suggestions = false, -- DESHABILITADO: Solo usar ask y edit
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
    },

    -- ========================================
    -- VENTANAS: Configuración de UI
    -- ========================================
    windows = {
      position = "right", -- Sidebar a la derecha
      wrap = true,
      width = 30, -- 30% del ancho de la pantalla
      sidebar_header = {
        align = "center",
        rounded = true,
      },
    },

    -- ========================================
    -- HIGHLIGHTS: Colores y temas
    -- ========================================
    highlights = {
      diff = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },

    -- ========================================
    -- DIFF: Configuración de diffs
    -- ========================================
    diff = {
      autojump = true,
      list_opener = "copen",
    },
  },

  -- ========================================
  -- KEYMAPS PERSONALIZADOS
  -- ========================================
  keys = {
    -- ATAJOS PRINCIPALES
    {
      "<leader>aa",
      function()
        require("avante.api").ask()
      end,
      desc = "Avante: Ask",
      mode = { "n", "v" },
    },
    {
      "<leader>ae",
      function()
        require("avante.api").edit()
      end,
      desc = "Avante: Edit",
      mode = "v",
    },
    {
      "<leader>ar",
      function()
        require("avante.api").refresh()
      end,
      desc = "Avante: Refresh",
    },

    -- ATAJOS DE SIDEBAR
    {
      "<leader>at",
      function()
        require("avante").toggle()
      end,
      desc = "Avante: Toggle Sidebar",
    },

    -- CHAT Y NAVEGACIÓN
    {
      "<leader>af",
      function()
        require("avante").focus()
      end,
      desc = "Avante: Focus Sidebar",
    },
    {
      "<leader>ah",
      function()
        require("avante.history").open()
      end,
      desc = "Avante: History",
    },

    -- NOTA: Los siguientes atajos solo funcionan dentro del sidebar de avante:
    -- <CR> (normal) / <C-s> (insert) - Enviar query
    -- <Esc> o q - Salir
    -- @ - Agregar archivo al contexto
    -- d - Remover archivo del contexto
    -- co - Elegir versión actual (en conflictos)
    -- ct - Elegir versión incoming (en conflictos)
    -- ]x / [x - Navegar entre conflictos
  },

  config = function(_, opts)
    require("avante").setup(opts)

    -- El API key se obtiene automáticamente de la variable de entorno ANTHROPIC_API_KEY
    -- Configúralo en tu sistema:
    --   macOS/Linux (Zsh): Agrega a ~/.zshrc o ~/.zshenv:
    --     export ANTHROPIC_API_KEY="tu-api-key-aqui"
    --   Windows (PowerShell): Agrega a $PROFILE:
    --     $env:ANTHROPIC_API_KEY = "tu-api-key-aqui"
    --   Windows (Sistema): Variables de entorno del sistema

    -- Desactivar avante en ventanas del picker (similar a Codeium)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "snacks_picker", "snacks_picker_input", "snacks_picker_list" },
      callback = function()
        vim.b.avante_enabled = false
      end,
      desc = "Desactivar Avante en Snacks picker"
    })

    -- Configurar statusline global (requerido para que las vistas se colapsen correctamente)
    vim.opt.laststatus = 3
  end,
}
