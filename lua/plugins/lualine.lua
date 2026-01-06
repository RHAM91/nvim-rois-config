return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

    if bajo_recurso then
      -- Configuración ultra-simplificada para modo bajo recurso
      require('lualine').setup({
        options = {
          icons_enabled = false,           -- Sin iconos
          theme = 'auto',
          component_separators = '',       -- Sin separadores
          section_separators = '',         -- Sin separadores
          globalstatus = true,             -- Una sola statusline (ahorra recursos)
          refresh = {
            statusline = 2000,             -- Actualizar cada 2 segundos
            tabline = 2000,
            winbar = 2000,
          }
        },
        sections = {
          lualine_a = { 'mode' },          -- Solo modo
          lualine_b = {},                  -- Vacío
          lualine_c = { { 'filename', path = 0 } },  -- Solo nombre de archivo
          lualine_x = {},                  -- Vacío
          lualine_y = {},                  -- Vacío
          lualine_z = { 'location' }       -- Solo ubicación
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        extensions = {}                    -- Sin extensiones
      })
    else
      -- Configuración normal completa
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              'filename',
              path = 1,
            }
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { 'neo-tree', 'lazy', 'mason', 'oil' }
      })
    end
  end,
}
