return {
    "declancm/cinnamon.nvim",
    version = "*",
    config = function()
        local cinnamon = require("cinnamon")

        cinnamon.setup({
            -- Habilitar keymaps automáticos
            keymaps = {
                basic = true, -- Habilita Ctrl+D/U/F/B, búsquedas, etc.
                extra = true, -- Habilita gg, G, j, k, h, l con counts, etc.
            },
            -- Opciones de configuración
            options = {
                mode = "cursor", -- Anima todos los movimientos del cursor
                delay = 1, -- Delay ultra bajo para respuesta inmediata (1ms)
                max_delta = {
                    line = false, -- Sin límite de líneas (false = animar siempre)
                    column = false, -- Sin límite de columnas
                    time = 100, -- Duración máxima muy corta (100ms) para scroll rápido
                },
                step_size = {
                    vertical = 3, -- Aún más líneas por paso para scroll más rápido
                    horizontal = 6, -- Más columnas por paso
                },
            },
        })

        -- Sobrescribir keymaps para j/k sin count también (para animación siempre)
        local scroll = cinnamon.scroll

        -- j y k normales (sin count) con gj/gk para respetar wrap
        vim.keymap.set("n", "j", function()
            scroll("gj")
        end, { silent = true, desc = "Bajar con animación" })

        vim.keymap.set("n", "k", function()
            scroll("gk")
        end, { silent = true, desc = "Subir con animación" })

        vim.keymap.set("x", "j", function()
            scroll("gj")
        end, { silent = true, desc = "Bajar con animación" })

        vim.keymap.set("x", "k", function()
            scroll("gk")
        end, { silent = true, desc = "Subir con animación" })

        -- h y l normales también
        vim.keymap.set("n", "h", function()
            scroll("h")
        end, { silent = true, desc = "Izquierda con animación" })

        vim.keymap.set("n", "l", function()
            scroll("l")
        end, { silent = true, desc = "Derecha con animación" })

        vim.keymap.set("x", "h", function()
            scroll("h")
        end, { silent = true, desc = "Izquierda con animación" })

        vim.keymap.set("x", "l", function()
            scroll("l")
        end, { silent = true, desc = "Derecha con animación" })
    end,
}
