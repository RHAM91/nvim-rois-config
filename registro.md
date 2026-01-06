# Registro Técnico: Modo Dual de Bajo Recurso

Este documento contiene la documentación técnica completa de la implementación del sistema de modo dual (Normal/Bajo Recurso) en la configuración de Neovim.

## Índice

1. [Arquitectura General](#arquitectura-general)
2. [Variable de Control](#variable-de-control)
3. [Archivos Modificados](#archivos-modificados)
4. [Patrones de Implementación](#patrones-de-implementación)
5. [Mapa de Dependencias](#mapa-de-dependencias)
6. [Testing y Verificación](#testing-y-verificación)
7. [Troubleshooting](#troubleshooting)

---

## Arquitectura General

### Concepto
La configuración utiliza una **variable global booleana** (`vim.g.activar_modo_bajo_recurso`) que controla el comportamiento de plugins y opciones en tiempo de carga.

### Flujo de Ejecución
```
init.lua (línea 6)
    ↓
vim.g.activar_modo_bajo_recurso = false/true
    ↓
Carga de módulos:
    ├─→ config/options.lua (lee variable)
    ├─→ config/keymaps.lua (sin cambios)
    └─→ config/lazy.lua → plugins/*.lua (cada plugin lee variable)
```

### Principios de Diseño
1. **Single Source of Truth**: Una sola variable controla todo
2. **Graceful Degradation**: Funcionalidad core siempre disponible
3. **Lazy Evaluation**: Plugins leen la variable en su config/opts
4. **No Runtime Toggle**: Requiere reinicio de Neovim para cambiar modo

---

## Variable de Control

### Ubicación
**Archivo**: `init.lua`
**Línea**: 6

```lua
vim.g.activar_modo_bajo_recurso = false  -- true para activar modo bajo recurso
```

### Tipo de Dato
- **Tipo**: `boolean`
- **Valores válidos**: `true` | `false`
- **Scope**: Global (`vim.g`)

### Lectura en Plugins
Patrón estándar para leer la variable:
```lua
local bajo_recurso = vim.g.activar_modo_bajo_recurso or false
```

**Importante**: Usar `or false` como fallback para evitar `nil` si la variable no está definida.

---

## Archivos Modificados

### 1. init.lua

**Líneas modificadas**: 1-6

**Cambios**:
- Agregada sección de comentarios (líneas 1-5)
- Variable global `vim.g.activar_modo_bajo_recurso` (línea 6)

**Código**:
```lua
-- ========================================
-- MODO DE BAJO RECURSO
-- ========================================
-- Cambia a true si tu máquina tiene pocos recursos (≤8GB RAM, CPU antigua)
-- Esto optimizará Neovim reduciendo animaciones, parsers y funciones de UI pesadas
vim.g.activar_modo_bajo_recurso = false
```

---

### 2. lua/config/options.lua

**Líneas modificadas**:
- 15-22 (scrolloff condicional)
- 47-59 (performance settings)

**Lógica implementada**:

#### Scrolloff Condicional (líneas 15-22)
```lua
-- Scrolloff se configura dinámicamente en la sección Performance más abajo
if not (vim.g.activar_modo_bajo_recurso or false) then
  vim.opt.scrolloff = 8         -- Mantener 8 líneas de distancia (solo en modo normal)
end
```

#### Performance Settings (líneas 47-59)
```lua
local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

if bajo_recurso then
  vim.opt.updatetime = 1000        -- Más tiempo entre actualizaciones (menos uso de CPU)
  vim.opt.timeoutlen = 300         -- Más tiempo para mapeos (evita procesamiento innecesario)
  vim.opt.lazyredraw = true        -- No redibujar durante macros/scripts
  vim.opt.synmaxcol = 200          -- Limitar syntax highlighting a 200 columnas
  vim.opt.scrolloff = 3            -- Reducir scrolloff para menos cálculos
else
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 200
end
```

**Opciones afectadas**:
| Opción | Modo Normal | Modo Bajo Recurso | Impacto |
|--------|-------------|-------------------|---------|
| `updatetime` | 250ms | 1000ms | ↓ Frecuencia de eventos CursorHold |
| `timeoutlen` | 200ms | 300ms | ↓ Sensibilidad de mapeos |
| `lazyredraw` | false | true | ↓ Redibujado durante macros |
| `synmaxcol` | ilimitado | 200 | ↓ Syntax en líneas largas |
| `scrolloff` | 8 | 3 | ↓ Cálculos de scroll |

---

### 3. lua/plugins/smear-cursor.lua

**Líneas modificadas**: 3-4

**Estrategia**: **Deshabilitar completamente**

**Código**:
```lua
return {
    "sphamba/smear-cursor.nvim",
    -- Deshabilitar en modo bajo recurso (animaciones consumen CPU/GPU)
    enabled = not (vim.g.activar_modo_bajo_recurso or false),
    event = "VeryLazy",
    -- ...
}
```

**Razón**: Animaciones consumen CPU/GPU continuamente (60fps @ 17ms por frame).

---

### 4. lua/plugins/noice.lua

**Líneas modificadas**: 3-4

**Estrategia**: **Deshabilitar completamente**

**Código**:
```lua
return {
    "folke/noice.nvim",
    -- Deshabilitar en modo bajo recurso (UI avanzada consume recursos)
    enabled = not (vim.g.activar_modo_bajo_recurso or false),
    event = "VeryLazy",
    -- ...
}
```

**Razón**: UI compleja con renderizado de markdown, popups, notifications. Fallback a mensajes estándar de Neovim.

---

### 5. lua/plugins/satellite.lua

**Líneas modificadas**: 3-4

**Estrategia**: **Deshabilitar completamente**

**Código**:
```lua
return {
    'lewis6991/satellite.nvim',
    -- Deshabilitar en modo bajo recurso (minimap consume recursos)
    enabled = not (vim.g.activar_modo_bajo_recurso or false),
    event = 'VeryLazy',
    -- ...
}
```

**Razón**: Minimap scrollbar requiere procesamiento continuo para detectar posición, diagnósticos, git signs.

---

### 6. lua/plugins/bufferline.lua

**Líneas modificadas**: 7, 24-25, 29-31, 42

**Estrategia**: **Optimización parcial**

**Código**:
```lua
config = function()
    local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

    require("bufferline").setup({
      options = {
        -- Indicadores visuales (simplificados en modo bajo recurso)
        indicator = {
          icon = bajo_recurso and '|' or '▎',
          style = 'icon',
        },

        buffer_close_icon = bajo_recurso and 'x' or '',
        close_icon = bajo_recurso and 'X' or '',
        left_trunc_marker = '<',
        right_trunc_marker = '>',

        -- Diagnósticos (deshabilitado en modo bajo recurso)
        diagnostics = bajo_recurso and false or "nvim_lsp",
        -- ...
      },
    })
end
```

**Optimizaciones**:
| Elemento | Normal | Bajo Recurso | Ahorro |
|----------|--------|--------------|--------|
| Indicador buffer activo | `▎` (Unicode) | `\|` (ASCII) | Renderizado simple |
| Icono cerrar buffer | `` (Nerd Font) | `x` (ASCII) | Sin dependencia nerd-font |
| Icono cerrar general | `` (Nerd Font) | `X` (ASCII) | Sin dependencia nerd-font |
| Diagnósticos LSP | Habilitado | Deshabilitado | Sin queries LSP continuas |

---

### 7. lua/plugins/incline.lua

**Líneas modificadas**: 23, 27, 57-68

**Estrategia**: **Optimización parcial**

**Código**:
```lua
config = function()
    local incline = require('incline')
    local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

    incline.setup({
        render = function(props)
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
            if filename == '' then filename = '[Sin nombre]' end

            local modified = vim.bo[props.buf].modified
            local result = { { ' ' } }

            -- En modo bajo recurso, omitir iconos para reducir procesamiento
            if not bajo_recurso then
                local devicons = require('nvim-web-devicons')
                local ft_icon, ft_color = devicons.get_icon_color(filename)
                if ft_icon then
                    table.insert(result, { ft_icon, guifg = ft_color })
                    table.insert(result, { ' ' })
                end
            end

            table.insert(result, { filename })
            -- ...
        end,
    })
end
```

**Optimización**: Skip de llamada a `nvim-web-devicons` (costosa por buffer).

---

### 8. lua/plugins/treesitter.lua

**Líneas modificadas**: 6-54

**Estrategia**: **Parsers selectivos + highlighting condicional**

**Código**:
```lua
config = function()
    local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

    -- Parsers en modo bajo recurso: solo los absolutamente esenciales
    local parsers_bajo_recurso = {
        "lua",        -- Necesario para configuración de Neovim
        "vim",        -- Necesario para archivos Vim
        "javascript", -- Esencial para desarrollo
        "typescript", -- Esencial para desarrollo
        "vue",        -- CRÍTICO para comentarios contextuales en archivos Vue
    }

    -- Parsers completos en modo normal
    local parsers_completos = {
        "lua", "vim", "vimdoc",
        "javascript", "typescript", "vue",
        "html", "css", "json",
        "python", "markdown", "markdown_inline",
    }

    -- Seleccionar lista de parsers según el modo
    local parsers = bajo_recurso and parsers_bajo_recurso or parsers_completos

    local ok, ts = pcall(require, 'nvim-treesitter')
    if ok then ts.install(parsers) end

    -- Habilitar highlighting solo cuando sea necesario
    local filetypes = bajo_recurso
        and { "vue" }
        or { "vue", "javascript", "typescript", "html", "css", "lua" }

    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
    })
end
```

**Parsers incluidos**:
| Parser | Modo Normal | Modo Bajo Recurso | Razón |
|--------|-------------|-------------------|-------|
| lua | ✅ | ✅ | Config de Neovim |
| vim | ✅ | ✅ | Archivos Vim |
| vimdoc | ✅ | ❌ | Docs Vim (no esencial) |
| javascript | ✅ | ✅ | Desarrollo core |
| typescript | ✅ | ✅ | Desarrollo core |
| vue | ✅ | ✅ | **CRÍTICO** para comentarios contextuales |
| html | ✅ | ❌ | Puede usar syntax básico |
| css | ✅ | ❌ | Puede usar syntax básico |
| json | ✅ | ❌ | Puede usar syntax básico |
| python | ✅ | ❌ | Opcional |
| markdown | ✅ | ❌ | Opcional |
| markdown_inline | ✅ | ❌ | Opcional |

**Highlighting condicional**:
- **Modo normal**: Todos los filetypes listados
- **Modo bajo recurso**: Solo Vue (necesario para Comment.nvim con detección de contexto)

---

### 9. lua/plugins/lsp.lua

**Líneas modificadas**: 54, 76-78, 85, 100

**Estrategia**: **Deshabilitar features costosas**

**Código**:

#### Inlay Hints (líneas 76-78)
```lua
local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

local on_attach = function(client, bufnr)
    -- ...
    -- Deshabilitar inlay hints en modo bajo recurso (consumen procesamiento)
    if client.server_capabilities.inlayHintProvider and not bajo_recurso then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
end
```

#### Virtual Text (líneas 85-100)
```lua
vim.diagnostic.config({
    virtual_text = {
        -- Deshabilitar virtual text en modo bajo recurso (reduce procesamiento de renderizado)
        enabled = not bajo_recurso,
        prefix = '▶',
        spacing = 3,
        source = true,
        format = function(diagnostic)
            return diagnostic.message
        end,
    },
    severity_sort = true,
    update_in_insert = bajo_recurso and false or false,
    -- ...
})
```

**Features deshabilitadas en bajo recurso**:
| Feature | Costo | Alternativa |
|---------|-------|-------------|
| Inlay hints | Renderizado continuo de tipos inline | Ver tipos con `gh` (hover) |
| Virtual text | Renderizado de mensajes al final de línea | Ver diagnósticos con `<leader>d` |
| update_in_insert | Procesamiento en modo insert | Diagnósticos al salir de insert |

---

### 10. lua/plugins/blink-cmp.lua

**Líneas modificadas**: 12-66 (todo el opts convertido a función)

**Estrategia**: **Reducir sources y delays**

**Código**:
```lua
opts = function()
    local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

    return {
        -- ...
        sources = {
            -- En modo bajo recurso, limitar a LSP y path (más rápido)
            default = bajo_recurso
                and { 'lsp', 'path' }
                or { 'lsp', 'path', 'snippets', 'buffer' },
        },

        completion = {
            menu = {
                draw = {
                    -- Deshabilitar treesitter en completion en modo bajo recurso
                    treesitter = bajo_recurso and {} or { 'lsp' },
                },
            },
            documentation = {
                auto_show = false,
                auto_show_delay_ms = bajo_recurso and 500 or 200,
            },
        },
    }
end
```

**Sources comparación**:
| Source | Normal | Bajo Recurso | Ahorro |
|--------|--------|--------------|--------|
| lsp | ✅ | ✅ | - |
| path | ✅ | ✅ | - |
| snippets | ✅ | ❌ | Sin cache de snippets |
| buffer | ✅ | ❌ | Sin indexado de buffers |

**Delays**:
- `auto_show_delay_ms`: 200ms → 500ms (menos updates frecuentes)

**Treesitter en completion**: Deshabilitado (sin syntax highlighting en completion menu)

---

### 11. lua/plugins/extras.lua (gitsigns)

**Líneas modificadas**: 175, 180-185, 193, 196

**Estrategia**: **Símbolos simples + mayor debounce**

**Código**:
```lua
config = function()
    local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

    require('gitsigns').setup({
        signs = {
            -- Símbolos más simples en modo bajo recurso
            add          = { text = bajo_recurso and '+' or '█' },
            change       = { text = bajo_recurso and '~' or '█' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = bajo_recurso and '?' or '┆' },
        },
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol',
            delay = bajo_recurso and 2000 or 1000,
        },
        -- Reducir actualizaciones en modo bajo recurso
        update_debounce = bajo_recurso and 500 or 100,
        -- ...
    })
end
```

**Optimizaciones**:
| Configuración | Normal | Bajo Recurso | Ahorro |
|---------------|--------|--------------|--------|
| Símbolos add/change | `█` (bloque) | `+`/`~` (ASCII) | Renderizado simple |
| Símbolos untracked | `┆` (Unicode) | `?` (ASCII) | Renderizado simple |
| blame delay | 1000ms | 2000ms | Menos llamadas a git |
| update_debounce | 100ms | 500ms | Menos actualizaciones de diff |

---

### 12. lua/plugins/gitgraph.lua

**Líneas modificadas**: 6-7

**Estrategia**: **Lazy loading estricto**

**Código**:
```lua
return {
  'isakbm/gitgraph.nvim',
  -- Lazy loading: solo cargar cuando se use
  cmd = { 'GitGraph' },
  dependencies = { 'sindrets/diffview.nvim' },
  -- ...
}
```

**Optimización**: Plugin no se carga hasta que se ejecuta `:GitGraph` o `<leader>gh`.

**Sin cambios condicionales**: No se necesita, ya que lazy loading es suficiente.

---

## Patrones de Implementación

### Patrón 1: Deshabilitar Plugin Completo

**Uso**: Plugins de UI pesados (smear-cursor, noice, satellite)

```lua
return {
    "plugin-name",
    enabled = not (vim.g.activar_modo_bajo_recurso or false),
    -- resto de config
}
```

**Ventajas**:
- Plugin no se carga en memoria
- Sin overhead de lazy.nvim
- Limpio y simple

**Desventajas**:
- Pérdida total de funcionalidad

---

### Patrón 2: Configuración Condicional en config

**Uso**: Plugins que necesitan ajustes pero no deshabilitarse (bufferline, incline, gitsigns)

```lua
return {
    "plugin-name",
    config = function()
        local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

        require('plugin').setup({
            option1 = bajo_recurso and valor_bajo or valor_normal,
            option2 = {
                suboption = bajo_recurso and sub_bajo or sub_normal,
            },
        })
    end
}
```

**Ventajas**:
- Funcionalidad parcial preservada
- Ajustes granulares

**Desventajas**:
- Plugin se carga igual (consume RAM base)

---

### Patrón 3: Opts como Función

**Uso**: Cuando opts es objeto (blink-cmp)

```lua
return {
    "plugin-name",
    opts = function()
        local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

        return {
            option = bajo_recurso and valor_bajo or valor_normal,
        }
    end
}
```

**Ventajas**:
- Sintaxis más limpia que config
- lazy.nvim maneja la configuración

**Desventajas**:
- Solo funciona si plugin acepta opts

---

### Patrón 4: Lazy Loading con cmd/keys

**Uso**: Plugins que no se usan frecuentemente (gitgraph)

```lua
return {
    "plugin-name",
    cmd = { 'CommandName' },
    keys = {
        { '<leader>x', '<cmd>CommandName<cr>', desc = 'Description' },
    },
}
```

**Ventajas**:
- Carga diferida (ahorro en startup)
- Funciona en ambos modos

**Desventajas**:
- Lag inicial al primer uso

---

### Patrón 5: Configuración Dual en options.lua

**Uso**: Opciones globales de Vim

```lua
local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

if bajo_recurso then
    vim.opt.option1 = valor_bajo
    vim.opt.option2 = valor_bajo
else
    vim.opt.option1 = valor_normal
    vim.opt.option2 = valor_normal
end
```

**Ventajas**:
- Control total sobre opciones Vim
- Sin dependencias de plugins

**Desventajas**:
- Código verboso si hay muchas opciones

---

## Mapa de Dependencias

### Dependencias de Funcionalidad Core

```
LSP (vue_ls, vtsls, html, cssls, emmet)
    ├─→ SIEMPRE habilitado (ambos modos)
    └─→ Inlay hints: SOLO modo normal

Treesitter
    ├─→ Parser "vue": CRÍTICO (ambos modos)
    │   └─→ Requerido por: Comment.nvim + nvim-ts-context-commentstring
    ├─→ Parsers JS/TS: SIEMPRE (ambos modos)
    └─→ Parsers html/css/json/markdown: SOLO modo normal

Completion (blink-cmp)
    ├─→ Source "lsp": SIEMPRE (ambos modos)
    ├─→ Source "path": SIEMPRE (ambos modos)
    ├─→ Source "snippets": SOLO modo normal
    └─→ Source "buffer": SOLO modo normal

Git
    ├─→ gitsigns: SIEMPRE (símbolos diferentes)
    ├─→ lazygit: SIEMPRE (lazy loading cmd)
    └─→ gitgraph: SIEMPRE (lazy loading cmd)
```

### Dependencias de UI

```
UI Avanzada (SOLO modo normal)
    ├─→ noice.nvim
    ├─→ smear-cursor.nvim
    └─→ satellite.nvim

UI Básica (SIEMPRE, optimizada en bajo recurso)
    ├─→ bufferline (iconos simples en bajo recurso)
    ├─→ incline (sin iconos en bajo recurso)
    ├─→ lualine (sin cambios)
    └─→ indent-blankline/mini.indentscope (sin cambios)
```

### Plugins Sin Cambios

Estos plugins NO leen `activar_modo_bajo_recurso`:

```
- lualine.nvim (statusline)
- mini.indentscope (scope indicator)
- toggleterm.nvim (terminal)
- oil.nvim (file explorer)
- codeium.nvim (AI completion)
- claude-code.nvim (Claude integration)
- vim-visual-multi (multi-cursor)
- atac.nvim (API client)
- Comment.nvim (comentarios)
- nvim-autopairs (auto-pairs)
- telescope.nvim (fuzzy finder)
- diffview.nvim (git diffs)
- mason.nvim (LSP installer)
- conform.nvim (formatter)
- luasnip (snippets)
- snacks.nvim (utilities)
- themes (kanagawa, catppuccin, etc.)
```

**Razón**: Ya son eficientes o lazy-loaded por defecto.

---

## Testing y Verificación

### Checklist de Verificación Después de Cambiar Modo

#### 1. Verificar Variable Global
```vim
:lua print(vim.g.activar_modo_bajo_recurso)
```
**Esperado**: `true` o `false` (no `nil`)

#### 2. Verificar Plugins Deshabilitados (Modo Bajo Recurso)
```vim
:Lazy
```
En la UI de Lazy:
- `smear-cursor.nvim` debe aparecer como **disabled**
- `noice.nvim` debe aparecer como **disabled**
- `satellite.nvim` debe aparecer como **disabled**

#### 3. Verificar Options
```vim
:set updatetime?
:set timeoutlen?
:set lazyredraw?
:set synmaxcol?
:set scrolloff?
```

**Esperado (Modo Bajo Recurso)**:
```
updatetime=1000
timeoutlen=300
lazyredraw
synmaxcol=200
scrolloff=3
```

**Esperado (Modo Normal)**:
```
updatetime=250
timeoutlen=200
nolazyredraw
synmaxcol=0 (ilimitado)
scrolloff=8
```

#### 4. Verificar Treesitter Parsers
```vim
:TSInstallInfo
```

**Esperado (Modo Bajo Recurso)**: Solo lua, vim, javascript, typescript, vue instalados

**Esperado (Modo Normal)**: Todos los parsers listados instalados

#### 5. Verificar LSP Inlay Hints
Abrir archivo TypeScript, escribir:
```typescript
const suma = (a: number, b: number) => a + b
```

**Esperado (Modo Normal)**: Ver hints de tipos inline
**Esperado (Modo Bajo Recurso)**: Sin hints (usar `gh` para ver tipos)

#### 6. Verificar LSP Virtual Text
Introducir un error (ej: `const x = undefinedVar`):

**Esperado (Modo Normal)**: Ver mensaje de error al final de la línea
**Esperado (Modo Bajo Recurso)**: Solo icono 'E' en signcolumn (usar `<leader>d` para ver mensaje)

#### 7. Verificar Completion Sources
En insert mode, presionar `<C-Space>`:

**Esperado (Modo Normal)**: Ver completions de LSP, path, snippets, buffer
**Esperado (Modo Bajo Recurso)**: Solo LSP y path

#### 8. Verificar Bufferline
Abrir varios buffers:

**Esperado (Modo Normal)**: Iconos Unicode/Nerd Font, diagnósticos visibles
**Esperado (Modo Bajo Recurso)**: Iconos ASCII simples (`|`, `x`, `X`), sin diagnósticos

#### 9. Verificar Gitsigns
Modificar un archivo en repo git:

**Esperado (Modo Normal)**: Icono `█` en signcolumn
**Esperado (Modo Bajo Recurso)**: Icono `+` o `~` en signcolumn

---

### Script de Verificación Automática

Crear archivo `~/.config/nvim/test-modo.lua`:

```lua
local function test_modo()
    local bajo_recurso = vim.g.activar_modo_bajo_recurso or false
    local modo_str = bajo_recurso and "BAJO RECURSO" or "NORMAL"

    print("========================================")
    print("MODO ACTUAL: " .. modo_str)
    print("========================================")

    -- Verificar variable
    print("\n[✓] Variable global: " .. tostring(bajo_recurso))

    -- Verificar options
    print("\n[Options]")
    print("  updatetime: " .. vim.o.updatetime .. (bajo_recurso and " (esperado: 1000)" or " (esperado: 250)"))
    print("  timeoutlen: " .. vim.o.timeoutlen .. (bajo_recurso and " (esperado: 300)" or " (esperado: 200)"))
    print("  lazyredraw: " .. tostring(vim.o.lazyredraw) .. (bajo_recurso and " (esperado: true)" or " (esperado: false)"))
    print("  synmaxcol: " .. vim.o.synmaxcol .. (bajo_recurso and " (esperado: 200)" or " (esperado: 0)"))
    print("  scrolloff: " .. vim.o.scrolloff .. (bajo_recurso and " (esperado: 3)" or " (esperado: 8)"))

    -- Verificar plugins
    print("\n[Plugins Deshabilitados en Bajo Recurso]")
    local lazy_ok, lazy_config = pcall(require, 'lazy.core.config')
    if lazy_ok then
        local plugins = lazy_config.plugins
        local check = {"smear-cursor.nvim", "noice.nvim", "satellite.nvim"}
        for _, name in ipairs(check) do
            local plugin = plugins[name]
            if plugin then
                local enabled = plugin._.enabled
                print("  " .. name .. ": " .. (enabled and "ENABLED" or "DISABLED"))
            end
        end
    end

    -- Verificar treesitter parsers
    print("\n[Treesitter Parsers]")
    local ts_ok, ts_parsers = pcall(require, 'nvim-treesitter.info')
    if ts_ok then
        local installed = ts_parsers.installed_parsers()
        print("  Instalados: " .. table.concat(installed, ", "))
        if bajo_recurso then
            print("  Esperados: lua, vim, javascript, typescript, vue")
        else
            print("  Esperados: lua, vim, vimdoc, javascript, typescript, vue, html, css, json, python, markdown, markdown_inline")
        end
    end

    print("\n========================================")
end

vim.api.nvim_create_user_command('TestModo', test_modo, {})
```

**Uso**:
1. Agregar en init.lua: `require('test-modo')`
2. Ejecutar: `:TestModo`

---

## Troubleshooting

### Problema 1: Variable no se lee correctamente

**Síntoma**: Plugins no cambian de comportamiento al cambiar la variable

**Causa**: Variable leída antes de ser definida (orden de carga incorrecto)

**Solución**:
1. Verificar que `vim.g.activar_modo_bajo_recurso` está en línea 6 de init.lua
2. Verificar que está ANTES de `require("config.lazy")`
3. Reiniciar Neovim completamente

**Verificación**:
```vim
:lua print(vim.g.activar_modo_bajo_recurso)
```

---

### Problema 2: Plugins deshabilitados no vuelven a cargar

**Síntoma**: Después de cambiar `true → false`, plugins siguen deshabilitados

**Causa**: Lazy.nvim cachea el estado `enabled`

**Solución**:
1. Cambiar variable a `false` en init.lua
2. Ejecutar: `:Lazy clean`
3. Ejecutar: `:Lazy sync`
4. Reiniciar Neovim

**Alternativa más agresiva**:
```bash
# Salir de Neovim, luego:
rm -rf ~/.local/share/nvim/lazy/*
nvim  # Volverá a instalar todos los plugins
```

---

### Problema 3: Options no cambian

**Síntoma**: `updatetime`, `lazyredraw`, etc. no reflejan el modo correcto

**Causa**: Otro plugin o archivo de config sobreescribiendo las options

**Diagnóstico**:
```vim
:verbose set updatetime?
```
Mostrará qué archivo estableció el valor.

**Solución**:
1. Buscar el archivo indicado
2. Remover la línea que establece la option
3. Confiar solo en options.lua

---

### Problema 4: Treesitter no instala/desinstala parsers

**Síntoma**: Parsers incorrectos para el modo actual

**Solución**:
1. Cambiar modo en init.lua
2. Ejecutar manualmente:
```vim
:TSUninstall html css json python markdown markdown_inline  " Modo bajo recurso
:TSInstall html css json python markdown markdown_inline    " Modo normal
```

**Automatización futura**: Agregar en treesitter.lua:
```lua
-- Desinstalar parsers no necesarios en modo bajo recurso
if bajo_recurso then
    local to_uninstall = {"html", "css", "json", "python", "markdown", "markdown_inline"}
    for _, parser in ipairs(to_uninstall) do
        vim.cmd("TSUninstall! " .. parser)
    end
end
```

---

### Problema 5: Completion sigue mostrando snippets/buffer

**Síntoma**: En modo bajo recurso, completion muestra todas las sources

**Causa**: blink-cmp cachea la config

**Solución**:
1. Cambiar modo en init.lua
2. Ejecutar: `:lua require('blink.cmp').reload()`
3. Si persiste: Reiniciar Neovim

---

### Problema 6: LSP virtual text sigue visible

**Síntoma**: Virtual text aparece en modo bajo recurso

**Causa**: `vim.diagnostic.config()` no se vuelve a ejecutar

**Solución**:
1. Cambiar modo en init.lua
2. Ejecutar manualmente:
```vim
:lua vim.diagnostic.config({ virtual_text = { enabled = false } })
```
3. Reiniciar Neovim para cambio permanente

---

### Problema 7: Gitsigns no cambia símbolos

**Síntoma**: Símbolos siguen siendo Unicode en modo bajo recurso

**Causa**: gitsigns ya estaba cargado antes de cambiar modo

**Solución**:
1. Cambiar modo en init.lua
2. Ejecutar: `:Gitsigns detach` (en buffer actual)
3. Ejecutar: `:Gitsigns attach` (vuelve a cargar config)
4. O reiniciar Neovim

---

## Mejoras Futuras

### 1. Toggle Runtime Sin Reiniciar

**Implementación sugerida**:

Agregar en `lua/config/toggle-modo.lua`:
```lua
local M = {}

function M.toggle()
    local current = vim.g.activar_modo_bajo_recurso or false
    vim.g.activar_modo_bajo_recurso = not current

    -- Reload options
    vim.cmd('source ~/.config/nvim/lua/config/options.lua')

    -- Reload LSP config
    vim.diagnostic.config({ virtual_text = { enabled = current } })

    -- Reload plugins que soportan reload
    -- (requiere implementar reload en cada plugin)

    vim.notify("Modo cambiado a: " .. (current and "NORMAL" or "BAJO RECURSO"), vim.log.levels.INFO)
    vim.notify("Reinicia Neovim para aplicar todos los cambios", vim.log.levels.WARN)
end

vim.api.nvim_create_user_command('ToggleModo', M.toggle, {})

return M
```

**Limitaciones**:
- Plugins con `enabled = false` no se cargan hasta reiniciar
- Treesitter parsers requieren instalación manual
- Algunos plugins cachean config

---

### 2. Detección Automática de Recursos

**Implementación sugerida**:

En `init.lua`:
```lua
-- Auto-detectar recursos del sistema (Linux/macOS)
local function detect_low_resources()
    -- Detectar RAM total
    local ram_mb = 0
    if vim.fn.has('unix') == 1 then
        local handle = io.popen("free -m | grep Mem | awk '{print $2}'")
        if handle then
            ram_mb = tonumber(handle:read("*a"))
            handle:close()
        end
    end

    -- Detectar CPU cores
    local cpu_cores = tonumber(vim.loop.cpu_info()[1].model:match("%d+")) or 4

    -- Si RAM ≤ 8GB O CPU ≤ 4 cores → bajo recurso
    return (ram_mb > 0 and ram_mb <= 8192) or cpu_cores <= 4
end

-- Activar modo bajo recurso automáticamente si aplica
vim.g.activar_modo_bajo_recurso = detect_low_resources()
```

**Ventaja**: Usuario no necesita configurar manualmente

**Desventaja**: Detección puede fallar en Windows o sistemas virtualizados

---

### 3. Perfiles Personalizados

**Implementación sugerida**:

En `init.lua`:
```lua
-- Perfiles: "high", "medium", "low", "minimal"
vim.g.perfil_recursos = "medium"

-- Configurar según perfil
local perfiles = {
    high = {
        updatetime = 250,
        parsers = "todos",
        ui_plugins = true,
        inlay_hints = true,
    },
    medium = {
        updatetime = 500,
        parsers = "esenciales+html+css",
        ui_plugins = true,
        inlay_hints = false,
    },
    low = {
        updatetime = 1000,
        parsers = "esenciales",
        ui_plugins = false,
        inlay_hints = false,
    },
    minimal = {
        updatetime = 2000,
        parsers = "solo_vue",
        ui_plugins = false,
        inlay_hints = false,
    },
}

local config = perfiles[vim.g.perfil_recursos]
-- Aplicar config...
```

**Ventaja**: Mayor granularidad de control

**Desventaja**: Mayor complejidad de mantenimiento

---

### 4. Métricas de Rendimiento

**Implementación sugerida**:

Agregar en `lua/config/metrics.lua`:
```lua
local M = {}

function M.measure_startup()
    local start = vim.loop.hrtime()

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            local duration = (vim.loop.hrtime() - start) / 1e6  -- ms
            print(string.format("Startup time: %.2fms", duration))
        end
    })
end

function M.measure_memory()
    local mem = collectgarbage("count")  -- KB
    print(string.format("Lua memory: %.2fMB", mem / 1024))
end

vim.api.nvim_create_user_command('Metrics', function()
    M.measure_memory()
end, {})

M.measure_startup()

return M
```

**Uso**: Comparar startup time entre modos

---

## Mantenimiento

### Al Agregar un Nuevo Plugin

**Checklist**:

1. **Evaluar si necesita optimización**:
   - ¿Consume CPU/GPU continuamente? (animaciones, rendering) → Deshabilitar
   - ¿Consume RAM significativa? (caches, buffers) → Optimizar config
   - ¿Es esencial para desarrollo? → Dejar sin cambios

2. **Elegir patrón de implementación**:
   - UI pesada → Patrón 1 (deshabilitar completo)
   - Configurable → Patrón 2 o 3 (config condicional)
   - Rara vez usado → Patrón 4 (lazy loading)

3. **Documentar en este archivo**:
   - Agregar a sección "Archivos Modificados"
   - Actualizar "Mapa de Dependencias"
   - Agregar test en "Testing y Verificación"

4. **Actualizar CLAUDE.md**:
   - Agregar plugin a lista de optimizados/deshabilitados

---

### Al Modificar un Plugin Existente

**Proceso**:

1. Buscar plugin en este documento
2. Verificar patrón implementado actual
3. Realizar cambios manteniendo el patrón
4. Probar en ambos modos (normal y bajo recurso)
5. Actualizar documentación si cambia comportamiento

**Ejemplo**: Si cambiamos bufferline para usar diagnósticos en bajo recurso:

```diff
- diagnostics = bajo_recurso and false or "nvim_lsp",
+ diagnostics = "nvim_lsp",  -- Ahora siempre habilitado
```

Actualizar en este archivo:
- Sección "lua/plugins/bufferline.lua"
- Tabla de optimizaciones (quitar fila de diagnósticos)

---

### Versionado de Este Documento

**Historial de Cambios**:

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-01-06 | 1.0.0 | Creación inicial - Implementación modo dual |

**Formato de versión**: `MAJOR.MINOR.PATCH`
- MAJOR: Cambios incompatibles (ej: cambiar variable de control)
- MINOR: Nuevas optimizaciones/plugins
- PATCH: Correcciones, mejoras de docs

---

## Referencias

### Archivos Clave

- `init.lua:6` - Variable de control
- `lua/config/options.lua:47-59` - Performance settings
- `lua/plugins/*.lua` - Configs de plugins
- `CLAUDE.md:11-81` - Documentación de usuario

### Recursos Externos

- [Neovim Performance Tips](https://neovim.io/doc/user/starting.html#slow-start)
- [lazy.nvim Plugin Spec](https://github.com/folke/lazy.nvim#-plugin-spec)
- [Treesitter Performance](https://github.com/nvim-treesitter/nvim-treesitter#performance)
- [LSP Configuration](https://neovim.io/doc/user/lsp.html)

---

## Conclusión

Este sistema de modo dual permite que la misma configuración de Neovim funcione eficientemente en máquinas de diferentes capacidades, desde hardware moderno hasta CPUs de 3ra generación con 8GB RAM.

**Puntos clave**:
- ✅ Una sola variable controla todo
- ✅ Funcionalidad core siempre disponible
- ✅ Degradación elegante de features secundarias
- ✅ Documentación completa para mantenimiento futuro

**Para el futuro**: Este documento debe actualizarse con cada cambio relacionado a optimización de recursos.
