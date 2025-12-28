
-- ~/.config/nvim/lua/plugins/lsp.lua
-- Configuración completa con TypeScript para Vue

return {
  -- Mason: Gestor de LSP servers
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  
  -- Mason-LSPConfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'volar',                  -- Vue Language Server (vue-language-server)
          'vtsls',                  -- TypeScript/JavaScript (NECESARIO para volar)
          'html',                   -- HTML
          'cssls',                  -- CSS, SCSS, Less
          'emmet_language_server',  -- Emmet
        },
        automatic_installation = true,
      })
    end,
  },

  -- nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

        -- Hover: Cambiado de K a gh para evitar conflicto con Shift+k
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
      end

      -- ===== VTSLS (TypeScript/JavaScript - REQUERIDO para Vue) =====
      local vue_language_server_path = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

      vim.lsp.config.vtsls = {
        cmd = { 'vtsls', '--stdio' },
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'vue',
        },
        root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = '@vue/typescript-plugin',
                  location = vue_language_server_path,
                  languages = { 'vue' },
                  configNamespace = 'typescript',
                },
              },
            },
          },
        },
      }

      -- ===== Vue Language Server (vue_ls, anteriormente conocido como volar) =====
      vim.lsp.config.vue_ls = {
        cmd = { 'vue-language-server', '--stdio' },
        filetypes = { 'vue' },
        root_markers = { 'package.json', 'vue.config.js', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- ===== HTML =====
      vim.lsp.config.html = {
        cmd = { 'vscode-html-language-server', '--stdio' },
        filetypes = { 'html', 'vue' },
        root_markers = { 'package.json', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- ===== CSS/SCSS/Less =====
      vim.lsp.config.cssls = {
        cmd = { 'vscode-css-language-server', '--stdio' },
        filetypes = { 'css', 'scss', 'less', 'vue' },
        root_markers = { 'package.json', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
          scss = { validate = true },
          less = { validate = true },
        },
      }

      -- ===== EMMET =====
      vim.lsp.config.emmet_language_server = {
        cmd = { 'emmet-language-server', '--stdio' },
        filetypes = {
          'html',
          'css',
          'scss',
          'less',
          'javascriptreact',
          'typescriptreact',
          'vue',
          'svelte',
          'astro',
        },
        root_markers = { 'package.json', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Habilitar los LSP servers
      vim.lsp.enable('vtsls')
      vim.lsp.enable('vue_ls')
      vim.lsp.enable('html')
      vim.lsp.enable('cssls')
      vim.lsp.enable('emmet_language_server')
    end,
  },
}

