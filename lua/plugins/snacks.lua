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
                keys = {
                    { icon = " ", key = "f", desc = "Find Files", action = ":Telescope find_files" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
                header = [[
               ░███                 ██████                ░███                 
              ███▒▒▒███           ███░░░░░░███           ███░░░███              
              ███▒▒▒███           ███░░░░░░███           ███░░░███              
              ███▒▒▒███           ███░░░░░░███           ███░░░███              
              ███▒▒▒░░░███     ███▒▒▒░░░░░░░░░███     ███░░░░░░███              
              ███▒▒▒░░░███     ███▒▒▒░░░░░░░░░███     ███░░░░░░███              
              ███▒▒▒░░░███     ███▒▒▒░░░░░░░░░███     ███░░░░░░███              
              ███▒▒▒░░░▒▒▒█████▒▒▒▒▒▒░░░░░░░░░░░░█████░░░░░░░░░███              
              ███▒▒▒░░░▒▒▒█████▒▒▒▒▒▒░░░░░░░░░░░░█████░░░░░░░░░███              
              ███▒▒▒░░░▒▒▒██▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░██░░░░░░░░░███              
              ███▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░███              
              ███▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░███              
              ███▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░███              
              ███▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░███              
              ░░░███▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███░░░              
                ░███▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███░                
              ███▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░███              
              ███▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░███              
              ███▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░███░             
                ░██████████████████████████████████████████████                 
                                                                               
]],
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
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
