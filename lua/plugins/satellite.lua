return {
    'lewis6991/satellite.nvim',
    event = 'VeryLazy',
    config = function(_, opts)
        -- Proteger contra errores E565 durante operaciones de buffer
        local ok, satellite = pcall(require, 'satellite')
        if not ok then return end

        -- Envolver la configuración en vim.schedule para evitar conflictos
        -- con restauración de sesiones y operaciones de buffer
        vim.schedule(function()
            satellite.setup(opts)
        end)
    end,
    opts = {
        current_only = false,
        winblend = 50,
        zindex = 40,
        excluded_filetypes = {},
        width = 2,
        handlers = {
            cursor = {
                enable = true,
                -- Muestra tu posición actual en el archivo
                symbols = { '⎺', '⎻', '⎼', '⎽' }
            },
            diagnostic = {
                enable = true,
                -- Muestra diagnósticos LSP
                signs = { '-', '=', '≡' },
                min_severity = vim.diagnostic.severity.HINT,
            },
            gitsigns = {
                enable = true,
                -- Muestra cambios de git
                signs = {
                    add = "│",
                    change = "│",
                    delete = "-",
                }
            },
            marks = {
                enable = true,
                -- Muestra marcas (marks)
                key = 'm',
                show_builtins = false,
            },
            quickfix = {
                enable = true,
                -- Muestra items de quickfix
                signs = { '-', '=', '≡' },
            }
        },
    }
}
