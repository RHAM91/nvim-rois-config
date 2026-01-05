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
--vim.keymap.set('v', 'x', '"_x', { noremap = true, silent = true, desc = 'Cut sin copiar' })

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

-- ========================================
-- NAVEGACIÓN EN LÍNEAS AJUSTADAS (WRAP)
-- ========================================

-- Navegar por líneas visuales (ajustadas) en lugar de líneas lógicas
-- Útil cuando wrap está activado
vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true, desc = 'Bajar línea visual' })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true, desc = 'Subir línea visual' })
vim.keymap.set('n', '0', 'g0', { noremap = true, silent = true, desc = 'Inicio línea visual' })
vim.keymap.set('n', '$', 'g$', { noremap = true, silent = true, desc = 'Final línea visual' })

-- Atajos rápidos para inicio y final de línea con leader
vim.keymap.set('n', '<leader>h', '^', { noremap = true, silent = true, desc = 'Inicio de línea (primer carácter)' })
vim.keymap.set('n', '<leader>l', '$', { noremap = true, silent = true, desc = 'Final de línea' })

-- En modo visual: L (shift+l) selecciona hasta el final de la línea
vim.keymap.set('v', 'L', '$h', { noremap = true, silent = true, desc = 'Seleccionar hasta final de línea' })

-- Moverse entre ventanas: Ctrl+w seguido de h/j/k/l (nativo de Neovim)
-- Ctrl+w h = ventana izquierda
-- Ctrl+w j = ventana abajo
-- Ctrl+w k = ventana arriba
-- Ctrl+w l = ventana derecha
-- Otros comandos útiles: Ctrl+w w (siguiente), Ctrl+w q (cerrar), Ctrl+w v (split vertical), Ctrl+w s (split horizontal)

-- Para salir del modo terminal y navegar entre ventanas
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true, silent = true, desc = 'Terminal: Ventana izquierda' })
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true, silent = true, desc = 'Terminal: Ventana abajo' })
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true, silent = true, desc = 'Terminal: Ventana arriba' })
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true, silent = true, desc = 'Terminal: Ventana derecha' })

-- Redimensionar ventanas con flechas
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { noremap = true, silent = true, desc = 'Reducir altura' })
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { noremap = true, silent = true, desc = 'Aumentar altura' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true, desc = 'Reducir ancho' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true, desc = 'Aumentar ancho' })

-- Mantener selección visual al indentar
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = 'Indentar izquierda' })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = 'Indentar derecha' })

-- Mover líneas arriba/abajo (Shift+Alt+Flechas, como VSCode)
vim.keymap.set('n', '<S-A-Down>', ':m .+1<CR>==', { noremap = true, silent = true, desc = 'Mover línea abajo' })
vim.keymap.set('n', '<S-A-Up>', ':m .-2<CR>==', { noremap = true, silent = true, desc = 'Mover línea arriba' })
vim.keymap.set('v', '<S-A-Down>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Mover bloque abajo' })
vim.keymap.set('v', '<S-A-Up>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Mover bloque arriba' })

-- Alternativa con j/k (solo si las flechas no te gustan, descomentar si prefieres)
vim.keymap.set('n', '<S-A-j>', ':m .+1<CR>==', { noremap = true, silent = true, desc = 'Mover línea abajo' })
vim.keymap.set('n', '<S-A-k>', ':m .-2<CR>==', { noremap = true, silent = true, desc = 'Mover línea arriba' })
vim.keymap.set('v', '<S-A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Mover bloque abajo' })
vim.keymap.set('v', '<S-A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Mover bloque arriba' })

-- Limpiar búsqueda resaltada
vim.keymap.set('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true, desc = 'Limpiar búsqueda' })

-- Toggle wrap (activar/desactivar ajuste de línea)
vim.keymap.set('n', '<leader>w', ':set wrap!<CR>', { noremap = true, silent = true, desc = 'Toggle wrap' })

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

-- Emmet expandir con Ctrl+y
vim.keymap.set('i', '<C-y>', '<Plug>(emmet-expand-abbr)', { desc = 'Expandir Emmet' })

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

-- Selector de temas con Snacks picker
vim.keymap.set('n', '<leader>ts', function()
  local ok, snacks = pcall(require, 'snacks')
  if ok and snacks.picker then
    snacks.picker.colorschemes()
  else
    vim.notify('Snacks picker no disponible. Usa <leader>tc, tk, tl para cambiar temas', vim.log.levels.WARN)
  end
end, { desc = 'Tema: Selector (Snacks)' })

-- ========================================
-- TOGGLE INLAY HINTS (SUGERENCIAS DE TIPO)
-- ========================================

-- Activar/desactivar inlay hints (inferencia de tipos)
vim.keymap.set('n', '<leader>th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  local status = vim.lsp.inlay_hint.is_enabled() and "activadas" or "desactivadas"
  vim.notify('Inlay hints ' .. status, vim.log.levels.INFO)
end, { desc = 'Toggle: Inlay Hints (tipos inferidos)' })

-- ========================================
-- CLAUDE CODE: Asistente de IA
-- ========================================

-- Nota: Los atajos principales están configurados en lua/plugins/claude-code.lua
-- <leader>cl - Toggle Claude Code
-- <leader>ch - Claude Code Chat
-- <leader>cr - Claude Code Refresh
-- Atajos adicionales:

-- Verificar estado de Claude Code
vim.keymap.set('n', '<leader>cs', ':ClaudeCodeStatus<CR>', { desc = 'Claude Code: Status' })

-- Abrir dashboard de Anthropic para ver créditos
vim.keymap.set('n', '<leader>cd', function()
  local url = 'https://console.anthropic.com/settings/billing'
  local cmd

  -- Detectar el sistema operativo y usar el comando apropiado
  if vim.fn.has('mac') == 1 then
    cmd = 'open'
  elseif vim.fn.has('unix') == 1 then
    cmd = 'xdg-open'
  elseif vim.fn.has('win32') == 1 then
    cmd = 'start'
  else
    vim.notify('Sistema operativo no soportado para abrir URLs', vim.log.levels.ERROR)
    return
  end

  -- Abrir el navegador
  vim.fn.jobstart({ cmd, url }, { detach = true })
  vim.notify('Abriendo dashboard de Anthropic...', vim.log.levels.INFO)
end, { desc = 'Claude: Dashboard (ver créditos)' })
