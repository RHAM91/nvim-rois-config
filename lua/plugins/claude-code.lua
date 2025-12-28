-- ~/.config/nvim/lua/plugins/claude-code.lua
-- Integración oficial de Claude Code en Neovim

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Server Configuration
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "info", -- "trace", "debug", "info", "warn", "error"
      terminal_cmd = nil, -- Usa "claude" por defecto

      -- Selection Tracking
      track_selection = true,
      visual_demotion_delay_ms = 50,

      -- Terminal Configuration
      terminal = {
        split_side = "right", -- "left" o "right"
        split_width_percentage = 0.30,
        provider = "auto", -- "auto", "snacks", "native"
        auto_close = true,
      },

      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = true,
        keep_terminal_focus = false,
      },
    },
    config = true,
    keys = {
      { "<leader>aa", "<cmd>ClaudeCode<CR>", desc = "Claude: Toggle" },
      { "<leader>ac", "<cmd>ClaudeCodeChat<CR>", desc = "Claude: Chat" },
      { "<leader>ar", "<cmd>ClaudeCodeRefresh<CR>", desc = "Claude: Refresh" },
    },
  },
}
