# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration optimized for Vue.js, TypeScript, and JavaScript development with AI assistance integration (Codeium and Claude Code). The configuration uses lazy.nvim for plugin management and follows a modular structure.

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
- `codeium.lua` - AI code suggestions
- `claude-code.lua` - Claude Code integration
- `formatter.lua` - conform.nvim with Prettier (4-space indentation)
- `luasnip-config.lua` - Custom snippets for JS/TS/Vue
- `toggleterm.lua` - Floating terminal configuration

## Critical Architecture Notes

### Keybinding Conflict Resolution Strategy
This configuration carefully manages conflicts between multiple completion and navigation systems:

1. **Window navigation uses `Ctrl+Shift` instead of `Ctrl`** - Prevents conflicts with Codeium (`<C-k>`, `<C-l>`) and blink.cmp (`<C-n>`, `<C-p>`)

2. **Hover documentation remapped from `K` to `gh`** - The default LSP hover key `K` conflicts with the remapped paragraph jump `Shift+k`

3. **blink.cmp uses `<C-g>` instead of `<C-y>`** - Custom accept key to avoid conflicts

4. **Codeium has custom Tab binding** - `<Tab>` accepts Codeium suggestions (codeium.lua:16-18)

5. **LuaSnip navigation conflicts with Codeium** - Both want `<C-l>`. LuaSnip takes precedence when a snippet is active

6. **ESC clears search highlight** - Remapped to `:noh` instead of default behavior (keymaps.lua:87)

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
- `Ctrl+Shift+h/j/k/l` - Navigate between windows (works in normal AND terminal mode)
- Arrow keys with `Ctrl` - Resize windows

### LSP Navigation
- `gh` - Show hover documentation (remapped from default `K` to avoid conflict with paragraph navigation)
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
- Keybindings: `<leader>aa` (toggle), `<leader>ac` (chat), `<leader>ar` (refresh)

### LuaSnip (Custom Snippets)
- Custom snippets defined for JavaScript, TypeScript, and Vue
- Notable snippets: `cl` (console.log), `fn` (function), `af` (arrow function), `vbase` (Vue SFC template)
- Navigate placeholders: `<C-l>` (next), `<C-h>` (previous)
- Note: These conflict with Codeium's `<C-l>` when snippet is active

### Smooth Scrolling & Cursor Effects
Two plugins work together for fluid navigation:

**cinnamon.nvim** - Smooth scroll animations
- Animates ALL cursor movements (`j`, `k`, `h`, `l`, `gg`, `G`, etc.)
- Fast response time (3ms delay) for immediate feedback
- Short animation duration (200ms max) for snappy feel
- Keymaps enabled: basic (Ctrl+D/U/F/B, searches) and extra (all movements)
- Configuration in `lua/plugins/cinnamon.lua`

**smear-cursor.nvim** - Visual cursor trail/smear effect
- Creates a smooth "trail" effect behind the cursor as it moves
- Works in both normal and insert mode
- Customizable stiffness (0.7) and trailing (0.5) for balanced effect
- 60fps animation (~17ms interval) for smooth visuals
- Toggle with `:SmearCursorToggle` if needed
- Configuration in `lua/plugins/smear-cursor.lua`

## Plugin Notes

### nvim-autopairs
Configured with custom rules for HTML/Vue tag auto-indentation. When pressing Enter between tags, automatically creates properly indented structure.

### Oil.nvim
Alternative file explorer that allows editing directories like text files. Opened with `-` key. Configured to use trash for deletions.

### ToggleTerm
Floating terminal with curved borders. Opens with `<C-t>`. Default size: 120x30. Exit terminal mode with `<Esc><Esc>` or use `<C-Shift-h/j/k/l>` to navigate to other windows while in terminal mode.

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
- **No Treesitter** - Intentionally excluded to avoid parser errors

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
