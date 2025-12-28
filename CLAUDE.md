# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration optimized for Vue.js, TypeScript, and JavaScript development. The configuration uses lazy.nvim for plugin management and follows a modular structure with separate configuration files.

## Configuration Structure

The configuration is organized modularly:

- `init.lua` - Entry point that loads config modules in order: options → keymaps → lazy
- `lua/config/options.lua` - Global Neovim settings (leader key, display options, performance)
- `lua/config/keymaps.lua` - All custom keybindings
- `lua/config/lazy.lua` - Lazy.nvim bootstrap and setup
- `lua/plugins/` - Individual plugin configurations (auto-loaded by lazy.nvim)

## LSP Architecture

The LSP setup uses the new Neovim 0.11+ `vim.lsp.config` API:

### Critical LSP Dependencies

**vtsls** (TypeScript/JavaScript) is REQUIRED for Vue development. It provides:
- TypeScript/JavaScript language support
- Integration with Vue through `@vue/typescript-plugin`
- The `vue_language_server_path` must point to the installed vue-language-server package

### LSP Configuration Pattern

Each LSP server uses `vim.lsp.config.<server_name>` with:
- `cmd` - Command to start the server
- `filetypes` - File types the server handles
- `root_markers` - Files that indicate project root
- `capabilities` - From blink.cmp for completion
- `on_attach` - Function to set keybindings when LSP attaches

After configuration, servers are enabled with `vim.lsp.enable('<server_name>')`.

### LSP Servers Configured

- `vtsls` - TypeScript/JavaScript (includes Vue plugin integration)
- `vue_ls` - Vue Language Server (formerly Volar)
- `html` - HTML (also handles HTML in Vue files)
- `cssls` - CSS/SCSS/Less (also handles styles in Vue files)
- `emmet_language_server` - Emmet abbreviations

## Key Custom Keybindings

**Leader key:** Space

### Visual Mode Behavior
- `c`, `d`, `x` in visual mode delete without copying (use black hole register `"_`)
- `p` in visual mode pastes without copying the replaced text

### Buffer Navigation
- `Shift+h` / `Shift+l` - Navigate between buffers (previous/next)
- `Shift+j` / `Shift+k` - Jump between paragraphs (remapped from `{` and `}`)

### LSP Navigation
- `gh` - Show hover documentation (remapped from default `K` to avoid conflict with paragraph navigation)
- `gd` - Go to definition
- `gr` - Show references
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions

### Emmet
- `Ctrl+e` in insert mode - Expand Emmet abbreviation

## Plugin Notes

### blink.cmp
Fast completion engine with preset='enter' keymap. Uses LSP, path, snippets, and buffer sources. Has ghost text enabled and auto-brackets.

### nvim-autopairs
Configured with custom rules for HTML/Vue tag auto-indentation. When pressing Enter between tags, automatically creates properly indented structure.

### Oil.nvim
Alternative file explorer that allows editing directories like text files. Opened with `-` key. Configured to use trash for deletions.

## Common Tasks

### Testing Configuration
```bash
nvim              # Open Neovim (plugins auto-install on first run)
:checkhealth      # Verify Neovim health
:checkhealth lsp  # Check LSP status
:LspInfo          # View active LSP servers
```

### Managing Plugins
```vim
:Lazy             # Open plugin manager UI
:Lazy sync        # Update all plugins
:Lazy clean       # Remove unused plugins
:Mason            # Manage LSP servers
```

### Troubleshooting LSP
```vim
:LspInfo                                           # Check which LSP servers are attached
:lua vim.cmd('e'..vim.lsp.get_log_path())         # View LSP logs
```

## Important Configuration Details

- **No swap files** - `swapfile = false` to avoid .swp files
- **Clipboard integration** - `clipboard = 'unnamedplus'` syncs with system clipboard
- **2-space indentation** - Tabs expand to 2 spaces
- **Relative line numbers** - Enabled with `relativenumber = true`
- **Smart case search** - Case-insensitive unless uppercase letters are used
- **No Treesitter** - Intentionally excluded to avoid parser errors

## File Types Supported

- Vue.js (Single File Components)
- TypeScript/JavaScript (including React)
- HTML
- CSS/SCSS/Less
- JSON
