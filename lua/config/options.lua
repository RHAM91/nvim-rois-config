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
vim.opt.scrolloff = 8         -- Mantener 8 líneas de distancia

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
vim.opt.updatetime = 250
vim.opt.timeoutlen = 200  -- Tiempo de espera para mapeos (reducido para respuesta más rápida)
vim.opt.ttimeoutlen = 10  -- Tiempo de espera para secuencias de teclas (ESC, flechas, etc) - CRÍTICO para WSL+tmux

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
-- Optimizado: solo FocusGained y BufEnter (CursorHold/CursorHoldI pueden causar lag en WSL)
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})
