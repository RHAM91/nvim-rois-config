return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  config = function()
    require("bufferline").setup({
      options = {
        -- Mostrar números de buffer para saltar rápido
        numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both"

        -- Indicador de buffer modificado (no guardado)
        modified_icon = '●',

        -- Botón de cerrar
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,

        -- Indicadores visuales
        indicator = {
          icon = '▎', -- Barra vertical en buffer activo
          style = 'icon', -- 'icon' | 'underline' | 'none'
        },

        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',

        -- Longitud máxima del nombre
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,

        -- Diagnósticos (errores/warnings del LSP)
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,

        -- Separadores entre buffers
        separator_style = "thin", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }

        -- Mostrar buffer actual siempre visible
        enforce_regular_tabs = false,
        always_show_bufferline = true,

        -- Offsets para explorador de archivos
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorador",
            text_align = "center",
            separator = true
          },
          {
            filetype = "NvimTree",
            text = "Explorador",
            text_align = "center",
            separator = true
          }
        },

        -- Colores personalizados
        highlights = {
          fill = {
            bg = '#1a1b26', -- Fondo de la barra
          },
          buffer_selected = {
            fg = '#A06CD5', -- Color morado para buffer activo
            bold = true,
            italic = false,
          },
          modified = {
            fg = '#e0af68', -- Amarillo para modificado
          },
          modified_selected = {
            fg = '#e0af68', -- Amarillo para modificado activo
          },
        },
      },
    })

    -- Atajos para navegar entre buffers (ya existen Shift+h/l, estos son alternativos)
    vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { noremap = true, silent = true, desc = 'Buffer: Pick' })
    vim.keymap.set('n', '<leader>bc', ':BufferLinePickClose<CR>', { noremap = true, silent = true, desc = 'Buffer: Pick Close' })
    vim.keymap.set('n', '<leader>1', ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true, desc = 'Buffer: Ir a 1' })
    vim.keymap.set('n', '<leader>2', ':BufferLineGoToBuffer 2<CR>', { noremap = true, silent = true, desc = 'Buffer: Ir a 2' })
    vim.keymap.set('n', '<leader>3', ':BufferLineGoToBuffer 3<CR>', { noremap = true, silent = true, desc = 'Buffer: Ir a 3' })
    vim.keymap.set('n', '<leader>4', ':BufferLineGoToBuffer 4<CR>', { noremap = true, silent = true, desc = 'Buffer: Ir a 4' })
    vim.keymap.set('n', '<leader>5', ':BufferLineGoToBuffer 5<CR>', { noremap = true, silent = true, desc = 'Buffer: Ir a 5' })
  end,
}
