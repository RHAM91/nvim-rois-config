return {
  'NachoNievaG/atac.nvim',
  dependencies = { 'akinsho/toggleterm.nvim' },
  config = function()
    -- Directorio de trabajo para los archivos ATAC
    -- Usamos un directorio fijo para evitar problemas con archivos .json en el proyecto
    local atac_dir = vim.fn.expand('~/.local/share/atac')

    -- Crear el directorio si no existe
    if vim.fn.isdirectory(atac_dir) == 0 then
      vim.fn.mkdir(atac_dir, 'p')
    end

    -- Configurar ATAC
    local atac = require('atac')
    atac.setup({
      dir = atac_dir,
    })

    -- Terminal personalizado para ATAC con tamaño más grande
    local Terminal = require('toggleterm.terminal').Terminal
    local atac_term = Terminal:new({
      cmd = 'atac -d ' .. atac_dir,
      hidden = true,
      direction = 'float',
      float_opts = {
        border = 'curved',
        width = math.floor(vim.o.columns * 0.9),   -- 90% del ancho
        height = math.floor(vim.o.lines * 0.85),   -- 85% del alto
        winblend = 3,
      },
      on_open = function(term)
        vim.cmd('startinsert!')
        -- Mapear 'q' para cerrar ATAC
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {
          noremap = true,
          silent = true,
          desc = 'Cerrar ATAC'
        })
      end,
    })

    -- Función para toggle de ATAC personalizado
    local function toggle_atac()
      atac_term:toggle()
    end

    -- Sobrescribir el comando :Atac con nuestro terminal personalizado
    vim.api.nvim_create_user_command('Atac', toggle_atac, {
      desc = 'Toggle ATAC (API client)'
    })

    -- Keybinding para toggle de ATAC
    vim.keymap.set('n', '<leader>ta', toggle_atac, {
      noremap = true,
      silent = true,
      desc = 'Toggle ATAC (API client)'
    })
  end,
}
