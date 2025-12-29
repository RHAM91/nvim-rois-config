return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      -- Tamaño de la terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        elseif term.direction == "float" then
          return 20
        end
      end,
      -- Abrir en modo flotante por defecto
      direction = 'float',
      -- Cerrar la terminal al salir del proceso
      close_on_exit = true,
      -- Shell por defecto
      shell = vim.o.shell,
      -- Configuración de la ventana flotante
      float_opts = {
        border = 'curved',  -- 'single' | 'double' | 'shadow' | 'curved'
        width = 120,
        height = 30,
        winblend = 3,
      },
      -- Resaltar la terminal al abrirse
      highlights = {
        FloatBorder = {
          guifg = "#A06CD5",  -- Color del borde (mismo morado que git)
        },
      },
    })

    -- Atajo para toggle de terminal flotante (Space+t)
    vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>', { noremap = true, silent = true, desc = 'Toggle terminal flotante' })
    vim.keymap.set('t', '<leader>t', '<C-\\><C-n>:ToggleTerm<CR>', { noremap = true, silent = true, desc = 'Toggle terminal flotante' })

    -- Atajo para salir de la terminal al modo normal (ESC adicional)
    vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Salir al modo normal' })
  end,
}
