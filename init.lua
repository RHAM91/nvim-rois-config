-- ========================================
-- MODO DE BAJO RECURSO
-- ========================================
-- Cambia a true si tu máquina tiene pocos recursos (≤8GB RAM, CPU antigua)
-- Esto optimizará Neovim reduciendo animaciones, parsers y funciones de UI pesadas
vim.g.activar_modo_bajo_recurso = false

-- Configurar PowerShell como shell en Windows
if vim.fn.has('win32') == 1 then
  vim.o.shell = 'pwsh.exe -NoLogo'
  vim.o.shellcmdflag = '-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
end

require("config.options")
require("config.keymaps")
require("config.lazy")

-- Aplicar tema por defecto después de cargar plugins
vim.defer_fn(function()
  -- Cambia esto al tema que prefieras por defecto:
  -- 'catppuccin', 'kanagawa-wave', 'kanagawa-dragon', 'oh-lucy', 'oh-lucy-evening', 'tokyonight-night'
  pcall(vim.cmd.colorscheme, 'kanagawa-wave')
end, 0)