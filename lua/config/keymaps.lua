-- ~/.config/nvim/lua/config/keymaps.lua
-- Configuración de atajos de teclado

-- ========================================
-- MODO VISUAL: Evitar copiar al borrar
-- ========================================

-- Borrar sin copiar al registro (usa el "black hole register" _)
-- Cuando presionas 'c' en modo visual, borra sin copiar
vim.keymap.set('v', 'c', '"_c', { noremap = true, silent = true, desc = 'Borrar sin copiar' })

-- También aplica para 'd' (delete) y 'x' si lo deseas
vim.keymap.set('v', 'd', '"_d', { noremap = true, silent = true, desc = 'Delete sin copiar' })
vim.keymap.set('v', 'x', '"_x', { noremap = true, silent = true, desc = 'Cut sin copiar' })

-- Si quieres que paste en modo visual no copie lo reemplazado
vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = true, desc = 'Paste sin copiar lo reemplazado' })

-- ========================================
-- MODO NORMAL: Borrar sin copiar (opcional)
-- ========================================

-- Descomentar si también quieres evitar copiar en modo normal
-- vim.keymap.set('n', 'd', '"_d', { noremap = true, silent = true })
-- vim.keymap.set('n', 'dd', '"_dd', { noremap = true, silent = true })
-- vim.keymap.set('n', 'x', '"_x', { noremap = true, silent = true })
-- vim.keymap.set('n', 'c', '"_c', { noremap = true, silent = true })

-- ========================================
-- OTROS ATAJOS ÚTILES
-- ========================================

-- Salir de insert mode con jk
vim.keymap.set('i', 'jk', '<ESC>', { noremap = true, silent = true, desc = 'Salir de insert mode' })

-- Moverse entre ventanas más fácil
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Ventana izquierda' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Ventana abajo' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Ventana arriba' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Ventana derecha' })

-- Redimensionar ventanas con flechas
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { noremap = true, silent = true, desc = 'Reducir altura' })
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { noremap = true, silent = true, desc = 'Aumentar altura' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true, desc = 'Reducir ancho' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true, desc = 'Aumentar ancho' })

-- Mantener selección visual al indentar
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = 'Indentar izquierda' })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = 'Indentar derecha' })

-- Mover líneas seleccionadas arriba/abajo
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Mover líneas abajo' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Mover líneas arriba' })

-- Limpiar búsqueda resaltada
vim.keymap.set('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true, desc = 'Limpiar búsqueda' })

-- ========================================
-- NAVEGACIÓN: Saltar entre párrafos/bloques
-- ========================================

-- Navegar entre líneas en blanco (párrafos)
vim.keymap.set('n', '<S-j>', '}', { noremap = true, silent = true, desc = 'Bajar a siguiente párrafo' })
vim.keymap.set('n', '<S-k>', '{', { noremap = true, silent = true, desc = 'Subir a anterior párrafo' })

-- También en modo visual para mantener consistencia
vim.keymap.set('v', '<S-j>', '}', { noremap = true, silent = true, desc = 'Bajar a siguiente párrafo' })
vim.keymap.set('v', '<S-k>', '{', { noremap = true, silent = true, desc = 'Subir a anterior párrafo' })

-- ========================================
-- BUFFERS: Gestión de buffers
-- ========================================

-- Navegar entre buffers con Shift+h y Shift+l
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { noremap = true, silent = true, desc = 'Buffer anterior' })
vim.keymap.set('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true, desc = 'Buffer siguiente' })

-- Cerrar buffer actual sin cerrar la ventana
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { noremap = true, silent = true, desc = 'Cerrar buffer' })

-- Cerrar buffer forzado (sin guardar)
vim.keymap.set('n', '<leader>bD', ':bd!<CR>', { noremap = true, silent = true, desc = 'Cerrar buffer forzado' })

-- Cerrar todos los buffers excepto el actual
vim.keymap.set('n', '<leader>bo', ':%bd|e#|bd#<CR>', { noremap = true, silent = true, desc = 'Cerrar otros buffers' })

-- Listar buffers
vim.keymap.set('n', '<leader>bl', ':buffers<CR>', { noremap = true, silent = true, desc = 'Listar buffers' })

-- ========================================
-- EMMET: Expandir abreviaciones
-- ========================================

-- Emmet expandir con Ctrl+e (más fácil que el default Ctrl+y,)
vim.keymap.set('i', '<C-e>', '<Plug>(emmet-expand-abbr)', { desc = 'Expandir Emmet' })

-- Alternativamente, expandir con Tab (si no interfiere con autocompletado)
-- Esta función expande Emmet solo si estás después de una abreviación válida
local function emmet_or_tab()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, col)

  -- Detectar si hay una posible abreviación de Emmet
  if before_cursor:match('[%w%.#%[%]%-]+$') then
    -- Intentar expandir Emmet
    vim.cmd('normal! a')
    local ok = pcall(vim.fn['emmet#expandAbbr'], 0, '')
    if ok then
      return
    end
  end

  -- Si no se expandió Emmet, insertar Tab normal
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
end

-- Comentado por defecto para no interferir con blink.cmp
-- Descomenta si prefieres usar Tab para Emmet
-- vim.keymap.set('i', '<Tab>', emmet_or_tab, { noremap = true, silent = true, desc = 'Emmet o Tab' })

-- ========================================
-- TEMAS: Cambiar entre temas de colores
-- ========================================

-- Función para aplicar tema de forma segura
local function set_theme(theme_name, setup_fn)
  local ok, err = pcall(function()
    if setup_fn then
      setup_fn()
    end
    vim.cmd.colorscheme(theme_name)
  end)
  if not ok then
    vim.notify('Error al cargar tema: ' .. theme_name, vim.log.levels.ERROR)
  end
end

-- Catppuccin (variantes)
vim.keymap.set('n', '<leader>tc', function()
  set_theme('catppuccin')
end, { desc = 'Tema: Catppuccin Mocha' })

vim.keymap.set('n', '<leader>tC', function()
  require("catppuccin").setup({ flavour = "macchiato" })
  set_theme('catppuccin')
end, { desc = 'Tema: Catppuccin Macchiato' })

-- Kanagawa Wave (variante más clara)
vim.keymap.set('n', '<leader>tk', function()
  set_theme('kanagawa-wave')
end, { desc = 'Tema: Kanagawa Wave' })

-- Kanagawa Dragon (variante más oscura)
vim.keymap.set('n', '<leader>tK', function()
  set_theme('kanagawa-dragon')
end, { desc = 'Tema: Kanagawa Dragon' })

-- Oh-Lucy
vim.keymap.set('n', '<leader>tl', function()
  set_theme('oh-lucy')
end, { desc = 'Tema: Oh-Lucy' })

vim.keymap.set('n', '<leader>tL', function()
  set_theme('oh-lucy-evening')
end, { desc = 'Tema: Oh-Lucy Evening' })

-- Tokyo Night (bonus)
vim.keymap.set('n', '<leader>tt', function()
  set_theme('tokyonight-night')
end, { desc = 'Tema: Tokyo Night' })

-- Selector de temas con Telescope (si está instalado)
vim.keymap.set('n', '<leader>ts', function()
  local ok = pcall(vim.cmd, 'Telescope colorscheme')
  if not ok then
    vim.notify('Telescope no disponible. Usa <leader>tc, tk, tl para cambiar temas', vim.log.levels.WARN)
  end
end, { desc = 'Tema: Selector (Telescope)' })
