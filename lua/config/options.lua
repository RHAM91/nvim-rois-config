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

-- Búsqueda
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Backup y swap
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true