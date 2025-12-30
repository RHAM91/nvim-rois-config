return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = false },
        dashboard = {
            enabled = true,
            preset = {
                keys = function()
                    -- Verificar si existe una sesión para el directorio actual
                    local persistence = require("persistence")
                    local session_file = persistence.current()
                    local has_session = session_file and vim.fn.filereadable(session_file) == 1

                    local keys = {}

                    -- Si hay sesión, mostrar "Restore Session", sino mostrar "Abrir Oil"
                    if has_session then
                        table.insert(keys, { icon = " ", key = "r", desc = "Restore Session", action = function() require("persistence").load() end })
                    else
                        table.insert(keys, { icon = " ", key = "o", desc = "Abrir Oil", action = function()
                            -- El dashboard se cierra automáticamente antes de ejecutar la acción
                            -- Usamos vim.schedule y noautocmd para evitar conflictos con los autocommands del dashboard
                            vim.schedule(function()
                                -- Crear un buffer vacío sin disparar autocommands
                                vim.cmd("noautocmd enew")
                                -- Esperar otro ciclo y abrir Oil
                                vim.schedule(function()
                                    vim.cmd("Oil")
                                end)
                            end)
                        end })
                    end

                    table.insert(keys, { icon = " ", key = "q", desc = "Quit", action = ":qa" })

                    return keys
                end,
                header = [[
          ░█░          ████          ░█░          
         ██▒██       ██░░░░██       ██░██░        
         ██▒██       ██░░░░██       ██░██░        
         ██▒░░██   ░█▒▒░░░░░░█░   ██░░░██░        
         ██▒░░██   ░█▒▒░░░░░░█░   ██░░░██░        
         ██▒░░▒▒████▒▒▒░░░░░░░████░░░░░██░        
         ██▒░░▒▒▓▓▒▒▒▒▒░░░░░░░░░▓▓░░░░░██░        
         ██▒░░▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░██░        
         ██▒░░▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░██░        
          ░█▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█░          
         ██▒░░▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░██░        
         ██▒░░▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░██░        
          ░████████████████████████████░          
]],
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1, cwd = true, action = function() end },
                {
                    section = "terminal",
                    cmd = "pwd",
                    icon = " ",
                    title = "Current Directory",
                    indent = 2,
                    padding = 1,
                    height = 1,
                },
            },
        },
    },
    keys = {
        { "<leader>db", function() Snacks.dashboard() end, desc = "Dashboard" },
        { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
        { "<leader>dh", function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
        { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
        { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal", mode = { "n", "t" } },
        { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    },
    config = function(_, opts)
        local snacks = require("snacks")
        snacks.setup(opts)

        -- Configurar color del header del dashboard
        -- Opciones de colores:
        -- { fg = '#7aa2f7' }  -- Azul
        -- { fg = '#bb9af7' }  -- Púrpura
        -- { fg = '#7dcfff' }  -- Cyan/Turquesa
        -- { fg = '#9ece6a' }  -- Verde
        -- { fg = '#e0af68' }  -- Amarillo/Dorado
        -- { fg = '#f7768e' }  -- Rojo/Rosa
        -- { fg = '#ff9e64' }  -- Naranja
        -- { fg = '#c0caf5' }  -- Blanco azulado
        -- Extras: Agregar bold = true, italic = true para negrita/cursiva
        vim.api.nvim_set_hl(0, 'SnacksDashboardHeader', { fg = '#e0af68' })

        -- Abrir dashboard automáticamente al iniciar Neovim sin argumentos
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                if vim.fn.argc() == 0 then
                    snacks.dashboard.open()
                end
            end,
        })
    end,
}
