-- ============================================================================
-- CONFIGURACIÓN DE RENDIMIENTO
-- ============================================================================
-- true  = Modo optimizado (mejor rendimiento, menos animaciones)
-- false = Modo completo (más visual, animaciones fluidas)
local PERFORMANCE_MODE = true

return {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim", -- Requerido para UI
        "rcarriga/nvim-notify", -- Recomendado para notificaciones bonitas
    },
    opts = {
        -- Configuración de LSP
        lsp = {
            -- Sobrescribir markdown rendering
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- Requiere hrsh7th/nvim-cmp
            },
            -- Deshabilitar signature help automático (ese recuadro molesto)
            signature = {
                enabled = false,
            },
        },
        -- Presets para mejorar la experiencia
        presets = {
            bottom_search = true, -- Usar un diálogo clásico de búsqueda en la parte inferior
            command_palette = true, -- Posicionar cmdline y popupmenu juntos
            long_message_to_split = true, -- Mensajes largos se envían a un split
            inc_rename = false, -- Habilita un diálogo de input para inc-rename.nvim
            lsp_doc_border = false, -- Añadir border a documentación de hover y signature help
        },
        -- Rutas de mensajes (filtros según modo de rendimiento)
        routes = PERFORMANCE_MODE and {
            -- Modo optimizado: filtrar más mensajes innecesarios
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "written",
                },
                opts = { skip = true }, -- Ocultar "file written"
            },
            {
                filter = {
                    event = "msg_show",
                    find = "search hit BOTTOM",
                },
                opts = { skip = true }, -- Ocultar mensajes de búsqueda
            },
            {
                filter = {
                    event = "msg_show",
                    find = "search hit TOP",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = "%d+ lines yanked",
                },
                opts = { skip = true }, -- Ocultar mensajes de yank
            },
            {
                filter = {
                    event = "msg_show",
                    find = "%d+ fewer lines",
                },
                opts = { skip = true }, -- Ocultar mensajes de delete
            },
            {
                filter = {
                    event = "msg_show",
                    find = "%d+ more lines",
                },
                opts = { skip = true },
            },
        } or {
            -- Modo completo: solo filtrar mensajes básicos
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "written",
                },
                opts = { skip = true },
            },
        },
        -- Configuración de vistas
        views = {
            cmdline_popup = {
                position = {
                    row = 5,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = "auto",
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = 8,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = 10,
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                },
            },
        },
    },
    config = function(_, opts)
        require("noice").setup(opts)

        -- Configurar nvim-notify si está disponible (parametrizado por PERFORMANCE_MODE)
        local notify_ok, notify = pcall(require, "notify")
        if notify_ok then
            vim.notify = notify
            notify.setup({
                background_colour = "#000000",
                fps = PERFORMANCE_MODE and 24 or 60, -- Optimizado: 24fps | Completo: 60fps
                icons = {
                    DEBUG = "",
                    ERROR = "",
                    INFO = "",
                    TRACE = "✎",
                    WARN = "",
                },
                level = 2,
                minimum_width = 50,
                render = PERFORMANCE_MODE and "compact" or "default", -- Optimizado: compact | Completo: default
                stages = PERFORMANCE_MODE and "static" or "fade_in_slide_out", -- Optimizado: sin animación | Completo: con animación
                timeout = PERFORMANCE_MODE and 1500 or 3000, -- Optimizado: 1.5s | Completo: 3s
                top_down = true,
            })
        end

        -- Keybindings útiles para noice
        vim.keymap.set("n", "<leader>nl", function()
            require("noice").cmd("last")
        end, { desc = "Noice: Last Message" })

        vim.keymap.set("n", "<leader>nh", function()
            require("noice").cmd("history")
        end, { desc = "Noice: History" })

        vim.keymap.set("n", "<leader>nd", function()
            require("noice").cmd("dismiss")
        end, { desc = "Noice: Dismiss All" })

        vim.keymap.set("n", "<leader>ne", function()
            require("noice").cmd("errors")
        end, { desc = "Noice: Errors" })

        -- Si tienes telescope instalado, puedes ver notificaciones con:
        -- vim.keymap.set("n", "<leader>sn", ":Telescope notify<CR>", { desc = "Search Notifications" })
    end,
}
