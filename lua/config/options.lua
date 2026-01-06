-- ~/.config/nvim/lua/config/options.lua
-- O agrega estas líneas al inicio de tu init.lua

-- ========================================
-- OPCIONES ESENCIALES (FIX PARA ERRORES)
-- ========================================

-- FIX: &termguicolors must be set
vim.opt.termguicolors = true

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Números de línea
vim.opt.number = true
vim.opt.relativenumber = true

-- Scrolloff se configura dinámicamente en la sección Performance más abajo
if not (vim.g.activar_modo_bajo_recurso or false) then
  vim.opt.scrolloff = 8         -- Mantener 8 líneas de distancia (solo en modo normal)
end

-- Mouse
vim.opt.mouse = 'a'

-- Clipboard
vim.opt.clipboard = 'unnamedplus'

-- Tabs y espacios (4 espacios de indentación)
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- Apariencia
vim.opt.wrap = true              -- Activar ajuste de línea
vim.opt.linebreak = true         -- Romper líneas en palabras completas
vim.opt.breakindent = true       -- Mantener indentación en líneas ajustadas
vim.opt.showbreak = '↪ '         -- Mostrar símbolo al inicio de líneas ajustadas
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
--vim.opt.winbar = "%F %m"  -- Mostrar ruta completa del archivo

-- Búsqueda
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Performance
local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

if bajo_recurso then
  vim.opt.updatetime = 1000        -- Más tiempo entre actualizaciones (menos uso de CPU)
  vim.opt.timeoutlen = 300         -- Más tiempo para mapeos (evita procesamiento innecesario)
  vim.opt.lazyredraw = true        -- No redibujar durante macros/scripts
  vim.opt.synmaxcol = 200          -- Limitar syntax highlighting a 200 columnas (mejora rendimiento en líneas largas)
  vim.opt.scrolloff = 3            -- Reducir scrolloff para menos cálculos
else
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 200         -- Tiempo de espera para mapeos (reducido para respuesta más rápida)
end

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Backup y swap
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Auto-reload de archivos cuando cambian externamente
vim.opt.autoread = true

-- Detectar cambios externos automáticamente al volver a Neovim
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})
