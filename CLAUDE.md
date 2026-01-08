# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Idioma / Language

**IMPORTANTE: Todas las respuestas de Claude Code deben ser en ESPAÑOL.**

Claude Code debe responder siempre en español al usuario, incluyendo explicaciones, comentarios, mensajes de error, y cualquier otra comunicación. Los comentarios en el código también deben estar en español cuando sea apropiado.

## Modo de Bajo Recurso

Esta configuración incluye optimizaciones para máquinas con recursos limitados (≤8GB RAM, CPU antigua como Core i7 3ra generación).

### Activar Modo de Bajo Recurso

En `init.lua:6`, cambiar:
```lua
vim.g.activar_modo_bajo_recurso = false  -- Cambiar a true para activar
```

### Optimizaciones Implementadas

Cuando `activar_modo_bajo_recurso = true`:

1. **Options (options.lua)**
   - `updatetime`: 1000ms (vs 250ms) - Menos actualizaciones frecuentes
   - `timeoutlen`: 300ms (vs 200ms) - Más tiempo para mapeos
   - `lazyredraw`: true - No redibujar durante macros
   - `synmaxcol`: 200 - Limitar syntax highlighting en líneas largas
   - `scrolloff`: 3 (vs 8) - Menos cálculos de scroll

2. **Tema (init.lua)**
   - Modo normal: kanagawa-wave (tema completo con muchos highlight groups)
   - Modo bajo recurso: habamax (tema built-in, muy eficiente)
   - El usuario puede cambiar manualmente usando los keybindings (`<leader>tk`, etc.)

3. **Plugins de UI Deshabilitados**
   - smear-cursor.nvim - Animaciones de cursor (consumo GPU/CPU)
   - noice.nvim - UI avanzada de mensajes
   - satellite.nvim - Minimap scrollbar
   - mini.indentscope - Scope highlighting (dibuja constantemente)

4. **Plugins de UI Optimizados**
   - bufferline.nvim - Iconos ASCII simples, diagnósticos deshabilitados
   - incline.nvim - Sin iconos de archivo (nvim-web-devicons)
   - lualine.nvim - Sin iconos, sin separadores, refresh 2s (vs 1s)
   - snacks.nvim - Sin scroll suave, header simplificado en dashboard

5. **Treesitter (treesitter.lua)**
   - Parsers limitados: solo lua, vim, javascript, typescript, vue
   - Highlighting solo en archivos Vue (necesario para comentarios)
   - Parsers completos en modo normal: +html, css, json, python, markdown

6. **LSP (lsp.lua)**
   - Inlay hints deshabilitados (menos procesamiento)
   - Virtual text deshabilitado (reduce renderizado)
   - update_in_insert: false

7. **Completion (blink-cmp.lua)**
   - Sources limitadas: solo lsp y path (sin snippets ni buffer)
   - Treesitter en completion deshabilitado
   - auto_show_delay: 500ms (vs 200ms)

8. **Git (extras.lua, gitgraph.lua)**
   - gitsigns: símbolos ASCII simples (+, ~, ?), update_debounce 500ms
   - gitgraph: lazy loading con cmd (solo carga al usar)

### Impacto en Funcionalidad

**Funcionalidad Conservada:**
- LSP completo para Vue/JS/TS (vtsls, vue_ls, html, cssls, emmet)
- Completion funcional (LSP + path)
- Git signs y navegación
- Todos los keybindings
- Comentarios contextuales en Vue
- Formateo con Prettier
- Claude Code y Codeium

**Funcionalidad Reducida:**
- Tema simple (habamax en lugar de kanagawa-wave)
- Sin animaciones de cursor (smear-cursor)
- Sin mensajes UI elegantes (noice)
- Sin minimap scrollbar (satellite)
- Sin scope highlighting (mini.indentscope)
- Sin snippets en completion
- Sin inlay hints de TypeScript
- Sin virtual text de diagnósticos (usar `<leader>d` para ver)
- Iconos simplificados (ASCII en lugar de Unicode/Nerd Fonts)
- Statusline minimalista (lualine sin iconos)
- Sin scroll suave (snacks.nvim)

**Recomendación:** Activar modo bajo recurso si notas lag al escribir, cambiar buffers o navegar archivos.

## Overview

This is a Neovim configuration optimized for Vue.js, TypeScript, and JavaScript development with AI assistance integration (Codeium for inline completions and Claude Code). The configuration uses lazy.nvim for plugin management and follows a modular structure.

## Configuration Structure

The configuration is organized modularly:

- `init.lua` - Entry point that loads config modules in order: options → keymaps → lazy, then applies default theme (kanagawa-wave)
- `lua/config/options.lua` - Global Neovim settings (leader key, display options, performance, auto-reload)
- `lua/config/keymaps.lua` - All custom keybindings including theme switchers
- `lua/config/lazy.lua` - Lazy.nvim bootstrap and setup
- `lua/plugins/` - Individual plugin configurations (auto-loaded by lazy.nvim)

Key plugin files:
- `lsp.lua` - LSP configuration using Neovim 0.11+ `vim.lsp.config` API
- `blink-cmp.lua` - Fast completion engine
- `codeium.lua` - AI code suggestions (inline completions)
- `claude-code.lua` - Claude Code integration
- `extras.lua` - Additional plugins including nvim-ts-context-commentstring + Comment.nvim for Vue/JSX/TSX context-aware commenting
- `formatter.lua` - conform.nvim with Prettier (4-space indentation)
- `luasnip-config.lua` - Custom snippets for JS/TS/Vue
- `toggleterm.lua` - Floating terminal configuration
- `treesitter.lua` - Treesitter for syntax parsing (highlight enabled for comment detection)
- `indent-blankline.lua` - mini.indentscope for scope highlighting with vertical line

## Critical Architecture Notes

### Keybinding Conflict Resolution Strategy
This configuration carefully manages conflicts between multiple completion and navigation systems:

1. **Window/pane navigation uses `Ctrl+h/j/k/l` via vim-tmux-navigator** - Seamlessly navigate between Neovim windows AND tmux panes with the same keys. Alternative navigation: `<leader>w` + `h/j/k/l` or native `Ctrl+w` + `h/j/k/l`

2. **Hover documentation remapped from `K` to `gh`** - The default LSP hover key `K` conflicts with the remapped paragraph jump `Shift+k`

3. **Signature help remapped from `<C-k>` to `<leader>k`** - LSP signature help moved to avoid conflict with vim-tmux-navigator upward navigation

4. **blink.cmp uses `<C-g>` instead of `<C-y>`** - Custom accept key to avoid conflicts

5. **Codeium has custom Tab binding** - `<Tab>` accepts Codeium suggestions (codeium.lua:16-18)

6. **Comments use `cl` and `cb`** - Simple two-letter commands that don't conflict with any existing bindings

7. **LuaSnip navigation uses `<C-l>` in insert mode** - No conflicts with comment commands which use normal/visual mode

8. **ESC clears search highlight** - Remapped to `:noh` instead of default behavior (keymaps.lua:87)

9. **Claude Code uses `<leader>c` prefix** - Uses `<leader>cl` (toggle), `<leader>ch` (chat), `<leader>cr` (refresh), `<leader>cs` (status)

### Auto-reload Architecture
Files automatically reload when changed externally using autocmds on:
- FocusGained, BufEnter, CursorHold, CursorHoldI
- Calls `:checktime` to detect changes
- Skips reload in command-line mode (options.lua:63-70)

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
- `L` (capital L) - Select to end of line (keymaps.lua:52)

### Navigation
- `j`/`k` - Navigate by visual lines (wrap-aware) instead of logical lines
- `0`/`$` - Beginning/end of visual line (wrap-aware)
- `<leader>h` / `<leader>l` - Jump to start/end of line (keymaps.lua:48-49)
- `jk` in insert mode - Exit to normal mode (alternative to ESC)

### Buffer & Window Navigation
- `Shift+h` / `Shift+l` - Navigate between buffers (previous/next)
- `Shift+j` / `Shift+k` - Jump between paragraphs (remapped from `{` and `}`)
- `Ctrl+h/j/k/l` - Navigate between Neovim windows AND tmux panes seamlessly (via vim-tmux-navigator)
- `<leader>w` + `h/j/k/l` - Alternative window navigation (doesn't work across tmux panes)
- `Ctrl+w` + `h/j/k/l` - Native Neovim window navigation (doesn't work across tmux panes)
- Arrow keys with `Ctrl` - Resize windows

### LSP Navigation
- `gh` - Show hover documentation (remapped from default `K` to avoid conflict with paragraph navigation)
- `<leader>k` - Show signature help (remapped from `<C-k>` to avoid conflict with vim-tmux-navigator)
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Show references
- `gi` - Go to implementation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>f` - Format buffer
- `[d` / `]d` - Previous/next diagnostic

### Theme Switching
- `<leader>tk` / `<leader>tK` - Kanagawa Wave/Dragon
- `<leader>tc` / `<leader>tC` - Catppuccin Mocha/Macchiato
- `<leader>tl` / `<leader>tL` - Oh-Lucy/Oh-Lucy Evening
- `<leader>tt` - Tokyo Night
- `<leader>ts` - Theme selector (Telescope)

### Terminal
- `<C-t>` - Toggle floating terminal (works in normal and terminal mode)
- `<Esc><Esc>` - Exit terminal mode to normal mode

### Emmet
- `Ctrl+e` in insert mode - Expand Emmet abbreviation

### Code Comments
- `cl` - Toggle line comment (works in normal and visual mode)
- `cb` - Toggle block comment (works in normal and visual mode)
- **Context-aware** - Automatically detects language in multi-language files (Vue, JSX, TSX)
  - In Vue `<template>`: uses `<!-- HTML comments -->`
  - In Vue `<script>`: uses `// JavaScript comments`
  - In Vue `<style>`: uses `/* CSS comments */`

## AI Integration Architecture

This configuration integrates two AI systems that work together:

### blink.cmp (LSP Completion)
- Fast completion engine with `preset='enter'` keymap
- Accept with `<CR>` or `<C-g>` (not `<C-y>` - customized to avoid conflicts)
- Sources: LSP, path, snippets, buffer
- Ghost text enabled, auto-brackets enabled
- Documentation auto-shows after 200ms delay

### Codeium (AI Code Suggestions)
- Free AI-powered code completion
- **Manual mode disabled** (`codeium_manual = false`) - suggestions appear automatically
- Custom keybindings to avoid conflicts:
  - `<Tab>` - Accept full suggestion
  - `<C-k>` - Accept next word
  - `<C-l>` - Accept next line
  - `<C-;>` / `<C-,>` - Cycle suggestions
  - `<C-x>` - Clear suggestion
- **Important**: `<C-Space>` triggers Codeium, not blink.cmp (codeium.lua:45-47)

### Claude Code Integration
- Positioned on the right side (30% width)
- Terminal provider: auto (uses snacks.nvim if available)
- Auto-starts on Neovim launch
- Diff integration with vertical split, auto-close on accept

**Keybindings:**
- `<leader>cl` - Toggle Claude Code
- `<leader>ch` - Claude Code Chat
- `<leader>cr` - Claude Code Refresh
- `<leader>cs` - Claude Code Status
- `<leader>cd` - Open Anthropic Dashboard (check credits and billing)

### LuaSnip (Custom Snippets)
- Custom snippets defined for JavaScript, TypeScript, and Vue
- Notable snippets: `cl` (console.log), `fn` (function), `af` (arrow function), `vbase` (Vue SFC template)
- Navigate placeholders: `<C-l>` (next), `<C-h>` (previous)
- Note: These conflict with Codeium's `<C-l>` when snippet is active

### Cursor Effects

**smear-cursor.nvim** - Visual cursor trail/smear effect
- Creates a smooth "trail" effect behind the cursor as it moves
- Works in both normal and insert mode
- Customizable stiffness and trailing for balanced effect
- 60fps animation (~17ms interval) for smooth visuals
- Toggle with `:SmearCursorToggle` if needed
- Configuration in `lua/plugins/smear-cursor.lua`

### Multiple Cursors

**vim-visual-multi** - Advanced multi-cursor editing
- Modern successor to vim-multiple-cursors with enhanced features
- Works from normal mode (similar to VS Code/Sublime Text)
- Two modes: Cursor Mode (normal commands) and Extend Mode (visual-like)
- Configuration in `lua/plugins/vim-visual-multi.lua`

**Core Keybindings:**
- `Ctrl+n` - Select word under cursor (repeat for more occurrences)
- `Ctrl+Down/Up` - Create cursors vertically
- `n/N` - Next/previous occurrence in multi-cursor mode
- `[/]` - Navigate between cursors
- `q` - Skip current occurrence
- `Q` - Remove current cursor
- `Tab` - Toggle between Cursor/Extend modes
- `i/a/I/A` - Enter insert mode at all cursors
- `Esc` - Exit multi-cursor mode

**Advanced Commands:**
- `\\A` - Select all occurrences of word
- `\\/` - Regex search for selections
- `\\\\` - Add cursor at current position
- Standard Vim commands work: `c`, `d`, `y`, `r`, `~`

### API Client

**atac.nvim** - REST API client integrado en Neovim
- Cliente REST similar a Postman/Insomnia pero en la terminal
- Permite hacer peticiones HTTP (GET, POST, PUT, DELETE, etc.) sin salir de Neovim
- Gestión de colecciones de APIs y variables de entorno
- Directorio de trabajo: `~/.local/share/atac`
- Configuración en `lua/plugins/atac.lua`

**Keybindings:**
- `<leader>ta` - Toggle ATAC (abrir/cerrar)

**Comandos:**
- `:Atac` - Toggle ATAC interface
- `:AtacOpen` - Comando alternativo para abrir ATAC

**Notas importantes:**
- Requiere ATAC ≥ 0.13.0 instalado en el sistema
- Usa un directorio dedicado para evitar conflictos con archivos .json del proyecto
- Integrado con toggleterm.nvim para la interfaz de terminal

### UI & Notifications

**noice.nvim** - Modern UI for messages, cmdline and notifications
- Replaces the default Neovim UI for messages and command line
- Beautiful notifications with nvim-notify integration
- Command palette in center of screen
- Long messages automatically sent to split
- Configuration in `lua/plugins/noice.lua`

**Features:**
- Bottom search bar with better visibility
- Floating command line with autocomplete
- Elegant notification popups with animations
- Message history and filtering
- LSP progress messages

**Keybindings:**
- `<leader>nl` - Show last message
- `<leader>nh` - Show message history
- `<leader>nd` - Dismiss all notifications
- `<leader>ne` - Show error messages

### Treesitter Architecture

**nvim-treesitter** - Syntax parsing for context-aware features
- **Highlighting enabled** - Required for ts-context-commentstring to detect Vue sections
- **Indentation disabled** - Maintains current indentation behavior
- **Auto-install enabled** - Parsers install automatically when opening files
- **Languages supported** - Lua, Vim, JavaScript, TypeScript, Vue, HTML, CSS, JSON, Python, Markdown
- **Primary purposes** - Provides scope detection for hlchunk.nvim and language context for comments
- Configuration in `lua/plugins/treesitter.lua`

**Important Notes:**
- Highlighting is enabled specifically for comment detection in multi-language files (Vue, JSX, TSX)
- The Vue parser is critical for detecting template/script/style sections
- Parsers are installed via `:TSInstall` commands or automatically on file open

## Plugin Notes

### Comment.nvim + nvim-ts-context-commentstring
Sistema de comentarios inteligente con detección de contexto para archivos multi-lenguaje.

**Características:**
- **Detección automática de lenguaje** - Usa Treesitter para detectar el contexto actual
- **Soporte para Vue SFC** - Detecta si estás en `<template>`, `<script>` o `<style>`
- **Toggle inteligente** - El mismo atajo comenta/descomenta automáticamente
- **Funciona con JSX/TSX** - También detecta contexto en archivos React

**Atajos:**
- `cl` - Comentar/descomentar línea (normal y visual)
- `cb` - Comentar/descomentar bloque (normal y visual)

**Tipos de comentarios por contexto:**
- Vue `<template>`: `<!-- comentario HTML -->`
- Vue `<script>`: `// comentario JavaScript`
- Vue `<style>`: `/* comentario CSS */`
- JavaScript/TypeScript: `// comentario`
- CSS/SCSS: `/* comentario */`

**Configuración:**
- Comment.nvim: `lua/plugins/extras.lua:64-144`
- Requiere Treesitter con highlighting habilitado
- Requiere parser de Vue instalado: `:TSInstall vue`

### vim-tmux-navigator
Integración perfecta entre Neovim y tmux para navegación unificada.
- **Navegación unificada** - Usa `Ctrl+h/j/k/l` para navegar entre ventanas de Neovim Y paneles de tmux sin pensar
- **Detección inteligente** - Automáticamente detecta si estás en el borde de Neovim y pasa el control a tmux
- **Sin configuración manual** - Funciona out-of-the-box, no necesitas pensar en si estás en Vim o tmux
- **Configuración** - `lua/plugins/vim-tmux-navigator.lua`
- **Requisito tmux** - El plugin `christoomey/vim-tmux-navigator` debe estar instalado en tmux (línea 14 de `.tmux.conf`)

### nvim-autopairs
Configured with custom rules for HTML/Vue tag auto-indentation. When pressing Enter between tags, automatically creates properly indented structure.

### Oil.nvim
Alternative file explorer that allows editing directories like text files. Opened with `-` key. Configured to use trash for deletions.

### ToggleTerm
Floating terminal with curved borders. Opens with `<C-t>`. Default size: 120x30. Exit terminal mode with `<Esc><Esc>` or use `Ctrl+h/j/k/l` (via vim-tmux-navigator) o `<leader>w` + `h/j/k/l` to navigate to other windows while in terminal mode.

### GitGraph.nvim
Visualizador gráfico del historial de Git con ordenamiento topológico temporal.
- **Vista gráfica** - Muestra el árbol de commits con ramas visuales en columnas consistentes
- **Integración con Diffview** - Presiona Enter en un commit para ver el diff completo
- **Selección de rango** - Usa modo visual para seleccionar múltiples commits y ver diferencias
- **Información detallada** - Muestra hash, fecha, autor, rama y etiquetas
- **Colores personalizados** - 5 colores diferentes para distinguir ramas visualmente
- **Configuración** - `lua/plugins/gitgraph.lua`

**Keybindings:**
- `<leader>gh` - Abrir vista gráfica de Git (muestra hasta 5000 commits)
- `Enter` - Ver diff del commit bajo el cursor (requiere diffview.nvim)
- `Enter` (modo visual) - Ver diff entre commits seleccionados

**Dependencias:**
- `sindrets/diffview.nvim` - Opcional pero recomendado para ver diffs de commits

### atac.nvim
Cliente REST/API integrado en Neovim (similar a Postman/Insomnia).
- **Directorio de trabajo** - `~/.local/share/atac` (fijo para evitar conflictos con archivos .json del proyecto)
- **Keybinding** - `<leader>ta` para toggle
- **Comandos** - `:Atac` o `:AtacOpen`
- **Requisito** - ATAC ≥ 0.13.0 instalado en el sistema
- **Nota importante** - Usa un directorio dedicado separado del proyecto para evitar el bug conocido de cierre inmediato cuando hay archivos .json en el directorio de trabajo
- **Integración** - Usa toggleterm.nvim para la interfaz de terminal
- **Configuración** - `lua/plugins/atac.lua`

### Scope Highlighting (mini.indentscope)
Visual indicator for the current code block/scope with a vertical line.
- **Vertical line** - Shows `│` marking the current scope/block
- **Color** - Orange (`#ff9e64`) for high visibility
- **Works universally** - Functions consistently across all file types (Lua, JS, TS, Vue, etc.)
- **No performance impact** - Lightweight, only highlights current scope
- **File exclusions** - Disabled in help, dashboard, terminal, and plugin windows
- **Note** - Does not show horizontal lines; only vertical scope indicator

## Formatting Architecture

### conform.nvim Configuration
- **Auto-format on save** - Enabled with 500ms timeout (formatter.lua:47-52)
- **Prettier** - Primary formatter for JS/TS/Vue/CSS/HTML/JSON/Markdown
- **Custom Prettier config** - Uses 4 spaces (`--tab-width 4`) instead of default 2
- **LSP fallback** - Uses LSP formatting if no formatter configured
- **Error notifications** - Enabled when formatter not available

### Python & Lua Formatting
- Python: isort → black (run in sequence)
- Lua: stylua

### Manual Formatting
- `<leader>f` - Format current buffer manually with async execution

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

### Managing Formatters
```vim
:ConformInfo      # Check formatter status and configuration
:Mason            # Install formatters (prettier, stylua, black, isort)
```

### Troubleshooting LSP
```vim
:LspInfo                                           # Check which LSP servers are attached
:lua vim.cmd('e'..vim.lsp.get_log_path())         # View LSP logs
```

### Troubleshooting AI Assistants
```vim
:Codeium Auth     # Authenticate Codeium (required on first use)
:Codeium Enable   # Enable Codeium completions
:Codeium Disable  # Disable Codeium completions
:ClaudeCodeStatus # Check Claude Code connection status
```

## Important Configuration Details

- **No swap files** - `swapfile = false` to avoid .swp files
- **Clipboard integration** - `clipboard = 'unnamedplus'` syncs with system clipboard
- **4-space indentation** - Tabs expand to 4 spaces (options.lua:28-29, formatter.lua:42)
- **Relative line numbers** - Enabled with `relativenumber = true`
- **Smart case search** - Case-insensitive unless uppercase letters are used
- **Wrap enabled** - Lines wrap at word boundaries with visual indicators (`showbreak = '↪ '`)
- **Auto-reload** - Files automatically reload when changed externally (FocusGained, BufEnter, CursorHold)
- **Treesitter** - Minimal installation for syntax parsing (highlighting disabled, only used by hlchunk.nvim)

## Theme Configuration

### Default Theme
- **kanagawa-wave** - Set in init.lua:9 with `pcall(vim.cmd.colorscheme, 'kanagawa-wave')`
- Applied with `vim.defer_fn()` after plugin loading to ensure theme is loaded

### Available Themes
- Kanagawa (wave, dragon) - Japanese-inspired color schemes
- Catppuccin (mocha, macchiato) - Pastel themes with multiple flavors
- Oh-Lucy (default, evening) - Vibrant themes
- Tokyo Night - Modern popular theme

### Changing Default Theme
Edit init.lua:9 and replace 'kanagawa-wave' with desired theme name. Use `pcall()` wrapper to prevent errors if theme not loaded.

### Theme Switching at Runtime
Use keymaps defined in keymaps.lua:174-213 or `:Telescope colorscheme` for interactive selection.

## File Types Supported

- Vue.js (Single File Components)
- TypeScript/JavaScript (including React)
- HTML
- CSS/SCSS/Less
- JSON
- Lua
- Python
- Markdown
