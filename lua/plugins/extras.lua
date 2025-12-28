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
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
      })
    end,
  },

  -- Telescope: Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>ff', ':Telescope find_files<CR>', desc = 'Find files' },
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
}