-- ~/.config/nvim/lua/plugins/extras.lua (OPCIONAL)
-- Plugins adicionales útiles - SIN TREESITTER para evitar errores

return {
  -- Auto-pairs: Cierra automáticamente paréntesis, llaves, etc.
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local npairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')

      npairs.setup({
        check_ts = false,
        enable_check_bracket_line = true,
        ignored_next_char = "[%w%.]",
      })

      -- Regla para auto-indentar tags HTML/Vue
      -- Cuando escribes <div> y presionas Enter, crea:
      -- <div>
      --   |cursor aquí
      -- </div>
      npairs.add_rules({
        Rule('<', '>', {
          'html',
          'vue',
          'xml',
          'javascriptreact',
          'typescriptreact',
        })
          :with_pair(cond.before_regex('%a+'))
          :with_move(function(opts) return opts.char == '>' end),
      })

      -- Regla mejorada para tags de cierre
      -- Al presionar Enter entre > y < de tags, indenta automáticamente
      npairs.add_rules({
        Rule('>%s*$', '', {
          'html',
          'vue',
          'xml',
          'javascriptreact',
          'typescriptreact',
        })
          :only_cr()
          :replace_endpair(function()
            return '<BS><BS><CR><CR><UP><TAB>'
          end),
      })
    end,
  },

  -- Comentarios inteligentes
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('Comment').setup()
    end,
  },

  -- Colorizer: Muestra colores en CSS
  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('colorizer').setup({
        'css',
        'scss',
        'html',
        'javascript',
        'vue',
      }, {
        RGB      = true,
        RRGGBB   = true,
        names    = false,
        RRGGBBAA = true,
        rgb_fn   = true,
        hsl_fn   = true,
        css      = true,
        css_fn   = true,
      })
    end,
  },

  -- Git signs en el gutter
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '█' },  -- Bloque completo (más grueso)
          change       = { text = '█' },  -- Bloque completo (más grueso)
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        -- Personalizar colores de Git Signs
        -- Después de la configuración, establecer colores personalizados
        current_line_blame = false, -- Mostrar blame en línea actual (desactivado por defecto)
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Navegación entre hunks (cambios)
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Siguiente cambio git' })

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Cambio git anterior' })

          -- Acciones de Git
          vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = 'Git: Preview cambio' })
          vim.keymap.set('n', '<leader>gb', gs.blame_line, { buffer = bufnr, desc = 'Git: Blame línea' })
          vim.keymap.set('n', '<leader>gB', gs.toggle_current_line_blame, { buffer = bufnr, desc = 'Git: Toggle blame' })
          vim.keymap.set('n', '<leader>gs', gs.stage_hunk, { buffer = bufnr, desc = 'Git: Stage hunk' })
          vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = 'Git: Reset hunk' })
          vim.keymap.set('v', '<leader>gs', function() gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, { buffer = bufnr, desc = 'Git: Stage hunk' })
          vim.keymap.set('v', '<leader>gr', function() gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, { buffer = bufnr, desc = 'Git: Reset hunk' })
          vim.keymap.set('n', '<leader>gS', gs.stage_buffer, { buffer = bufnr, desc = 'Git: Stage buffer' })
          vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, { buffer = bufnr, desc = 'Git: Undo stage' })
          vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { buffer = bufnr, desc = 'Git: Reset buffer' })
          vim.keymap.set('n', '<leader>gd', gs.diffthis, { buffer = bufnr, desc = 'Git: Diff este archivo' })
        end,
      })

      -- Personalizar colores: líneas nuevas en morado claro
      vim.cmd([[
        highlight GitSignsAdd guifg=#A06CD5 ctermfg=140
        highlight GitSignsAddNr guifg=#A06CD5 ctermfg=140
        highlight GitSignsAddLn guibg=#2C3E50 ctermbg=236
      ]])
    end,
  },

  -- Telescope: Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader><leader>', ':Telescope find_files<CR>', desc = 'Find files' },
      { '<leader>fg', ':Telescope live_grep<CR>', desc = 'Live grep' },
      { '<leader>fb', ':Telescope buffers<CR>', desc = 'Buffers' },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
        },
      })
    end,
  },

  -- Neo-tree: Explorador de archivos
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle file explorer' },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },

  -- Which-key: Muestra atajos de teclado disponibles
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup()
    end,
  },

  -- Soporte mejorado para Vue
  {
    'posva/vim-vue',
    ft = 'vue',
  },

  -- Persistence: Restaurar sesión automáticamente por directorio
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/'), -- Directorio para sesiones
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' }, -- Qué guardar
    },
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'Restaurar sesión del directorio actual' },
      { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restaurar última sesión global' },
      { '<leader>qd', function() require('persistence').stop() end, desc = 'No guardar sesión al salir' },
      { '<leader>qD', function()
        local persistence = require('persistence')
        -- Primero detener el guardado automático
        persistence.stop()
        -- Luego borrar la sesión existente
        local session_file = persistence.current()
        if session_file and vim.fn.filereadable(session_file) == 1 then
          vim.fn.delete(session_file)
          vim.notify('Sesión borrada (no se guardará al salir): ' .. vim.fn.fnamemodify(session_file, ':t'), vim.log.levels.INFO)
        else
          vim.notify('No hay sesión guardada para este directorio', vim.log.levels.WARN)
        end
      end, desc = 'Borrar sesión del directorio actual' },
      { '<leader>qx', function()
        -- Guardar sesión limpia sin el buffer actual
        local current_buf = vim.api.nvim_get_current_buf()
        -- Cerrar el buffer actual
        require('snacks').bufdelete()
        -- Esperar un poco y luego guardar la sesión
        vim.defer_fn(function()
          require('persistence').save()
          vim.notify('Sesión actualizada (buffer removido)', vim.log.levels.INFO)
        end, 100)
      end, desc = 'Guardar sesión sin buffer actual' },
    },
    config = function(_, opts)
      require('persistence').setup(opts)

      -- Restaurar automáticamente la sesión del directorio actual al abrir Neovim
      -- Solo si se abrió sin archivos y existe una sesión para este directorio
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Solo restaurar si:
          -- 1. No se pasaron argumentos (archivos) a nvim
          -- 2. No estamos en el directorio home
          -- 3. Existe una sesión guardada para este directorio
          if vim.fn.argc() == 0 and vim.fn.getcwd() ~= vim.fn.expand('~') then
            local session_file = require('persistence').current()
            if session_file and vim.fn.filereadable(session_file) == 1 then
              -- Esperar un poco para que el dashboard se muestre primero
              vim.defer_fn(function()
                -- No cargar automáticamente, dejar que el usuario presione 'r' en el dashboard
              end, 100)
            end
          end
        end,
        nested = true,
      })
    end,
  },
}