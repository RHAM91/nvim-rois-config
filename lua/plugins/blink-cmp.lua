-- ~/.config/nvim/lua/plugins/blink-cmp.lua
-- Plugin de autocompletado ultra rápido

return {
  'saghen/blink.cmp',
  lazy = false,
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  version = 'v0.*',

  opts = function()
    local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

    return {
      keymap = {
        preset = 'enter',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<C-g>'] = { 'select_and_accept' },  -- Cambiado de C-y a C-g
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
      },

      sources = {
        -- En modo bajo recurso, limitar a LSP y path (más rápido)
        default = bajo_recurso
          and { 'lsp', 'path' }
          or { 'lsp', 'path', 'snippets', 'buffer' },
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            -- Deshabilitar treesitter en completion en modo bajo recurso
            treesitter = bajo_recurso and {} or { 'lsp' },
          },
        },
        documentation = {
          auto_show = false,  -- Solo mostrar cuando se presiona <C-Space>
          auto_show_delay_ms = bajo_recurso and 500 or 200, -- Mayor delay en bajo recurso
        },
        ghost_text = {
          enabled = false,  -- Deshabilitado para evitar conflicto visual con Codeium
        },
      },

      signature = {
        enabled = false  -- Deshabilitado para evitar recuadros molestos
      },
    }
  end,
}