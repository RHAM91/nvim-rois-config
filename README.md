# 🚀 Configuración de Neovim

Configuración completa de Neovim optimizada para desarrollo con Vue.js, TypeScript y JavaScript, con integración de IA (Codeium y Claude Code).

## 📋 Tabla de Contenidos

- [Instalación](#instalación)
- [Leader Key](#leader-key)
- [Navegación](#navegación)
- [Buffers](#buffers)
- [Ventanas](#ventanas)
- [Edición](#edición)
- [Modo Visual](#modo-visual)
- [LSP (Language Server Protocol)](#lsp-language-server-protocol)
- [Formateo de Código](#formateo-de-código)
- [Autocompletado (blink.cmp)](#autocompletado-blinkcmp)
- [Codeium (IA)](#codeium-ia)
- [Claude Code (IA)](#claude-code-ia)
- [Temas](#temas)
- [Emmet](#emmet)
- [Comentarios](#comentarios)
- [Barra de Estado (Statusline)](#barra-de-estado-statusline)
- [Explorador de Archivos](#explorador-de-archivos)
- [Búsqueda (Telescope)](#búsqueda-telescope)
- [Git](#git)
- [Plugins Instalados](#plugins-instalados)

---

## Instalación

### 1. Clonar configuración

```bash
git clone <tu-repo> ~/.config/nvim
```

### 2. Instalar dependencias

```bash
# Instalar Prettier (formateador)
npm install -g prettier

# Instalar Claude Code CLI (opcional)
curl -fsSL claude.ai/install.sh | bash
```

### 3. Abrir Neovim

```bash
nvim
```

Los plugins se instalarán automáticamente en el primer inicio.

### 4. Autenticar Codeium

```vim
:Codeium Auth
```

---

## Leader Key

La tecla **Leader** está configurada como **`Espacio`** (Space).

---

## Navegación

### Navegación Básica

| Atajo | Descripción |
|-------|-------------|
| `h` `j` `k` `l` | Izquierda, Abajo, Arriba, Derecha (líneas visuales con wrap) |
| `w` | Siguiente palabra |
| `b` | Palabra anterior |
| `e` | Final de palabra |
| `0` | Inicio de línea visual |
| `$` | Final de línea visual |
| `Space+h` | Ir al inicio de línea (primer carácter no blanco) |
| `Space+l` | Ir al final de línea |
| `gg` | Inicio del archivo |
| `G` | Final del archivo |
| `Space+w` | Activar/desactivar wrap (ajuste de línea) |

> 💡 **Nota:** Con wrap activado, `j`/`k` se mueven por líneas visuales (ajustadas), no por líneas lógicas.

### Navegación entre Párrafos

| Atajo | Descripción |
|-------|-------------|
| `Shift+j` | Bajar al siguiente párrafo (línea en blanco) |
| `Shift+k` | Subir al anterior párrafo (línea en blanco) |

### Navegación en Modo Insert

| Atajo | Descripción |
|-------|-------------|
| `jk` | Salir del modo insert (alternativa a ESC) |

---

## Buffers

### Navegación entre Buffers

| Atajo | Descripción |
|-------|-------------|
| `Shift+h` | Buffer anterior (izquierda) |
| `Shift+l` | Buffer siguiente (derecha) |

### Gestión de Buffers

| Atajo | Descripción |
|-------|-------------|
| `Space+bd` | Cerrar buffer actual |
| `Space+bD` | Cerrar buffer sin guardar (forzado) |
| `Space+bo` | Cerrar todos los buffers excepto el actual |
| `Space+bl` | Listar todos los buffers abiertos |

---

## Ventanas

### Navegación entre Ventanas

**IMPORTANTE:** Usa `Ctrl+Shift` para navegar entre ventanas (evita conflictos con Codeium)

| Atajo | Descripción |
|-------|-------------|
| `Ctrl+Shift+h` | Ir a ventana izquierda |
| `Ctrl+Shift+j` | Ir a ventana abajo |
| `Ctrl+Shift+k` | Ir a ventana arriba |
| `Ctrl+Shift+l` | Ir a ventana derecha |

> 💡 **Nota:** Funciona tanto en modo normal como en modo terminal (Claude Code)

### Redimensionar Ventanas

| Atajo | Descripción |
|-------|-------------|
| `Ctrl+Arriba` | Reducir altura |
| `Ctrl+Abajo` | Aumentar altura |
| `Ctrl+Izquierda` | Reducir ancho |
| `Ctrl+Derecha` | Aumentar ancho |

### Dividir Ventanas

```vim
:split      " Dividir horizontalmente
:vsplit     " Dividir verticalmente
:only       " Cerrar todas las ventanas excepto la actual
```

---

## Edición

### Copiar, Cortar y Pegar

| Atajo | Descripción |
|-------|-------------|
| `yy` | Copiar línea completa |
| `dd` | Cortar/eliminar línea completa |
| `p` | Pegar después del cursor |
| `P` | Pegar antes del cursor |

### Borrar sin Copiar (Modo Visual)

| Atajo | Descripción |
|-------|-------------|
| `c` | Cambiar/borrar sin copiar al registro |
| `d` | Eliminar sin copiar al registro |
| `x` | Cortar sin copiar al registro |
| `p` | Pegar sin copiar lo reemplazado |

### Deshacer y Rehacer

| Atajo | Descripción |
|-------|-------------|
| `u` | Deshacer |
| `Ctrl+r` | Rehacer |

### Búsqueda

| Atajo | Descripción |
|-------|-------------|
| `/palabra` | Buscar hacia adelante |
| `?palabra` | Buscar hacia atrás |
| `n` | Siguiente resultado |
| `N` | Resultado anterior |
| `ESC` | Limpiar resaltado de búsqueda |

---

## Modo Visual

### Selección

| Atajo | Descripción |
|-------|-------------|
| `v` | Modo visual (carácter por carácter) |
| `V` | Modo visual línea completa |
| `Ctrl+v` | Modo visual bloque |
| `L` (mayúscula) | Seleccionar hasta el final de línea |

### Indentación

| Atajo | Descripción |
|-------|-------------|
| `<` | Indentar a la izquierda (mantiene selección) |
| `>` | Indentar a la derecha (mantiene selección) |

### Mover Líneas

| Atajo | Descripción |
|-------|-------------|
| `J` | Mover líneas seleccionadas hacia abajo |
| `K` | Mover líneas seleccionadas hacia arriba |

---

## LSP (Language Server Protocol)

### Navegación de Código

| Atajo | Descripción |
|-------|-------------|
| `gd` | Ir a definición |
| `gD` | Ir a declaración |
| `gr` | Ver referencias |
| `gi` | Ir a implementación |
| `gh` | Mostrar documentación (hover) |

### Diagnósticos y Errores

| Atajo | Descripción |
|-------|-------------|
| `[d` | Ir al error anterior |
| `]d` | Ir al siguiente error |
| `Space+d` | Abrir ventana flotante con diagnóstico |

### Refactorización

| Atajo | Descripción |
|-------|-------------|
| `Space+rn` | Renombrar símbolo |
| `Space+ca` | Acciones de código (code actions) |

### LSP Servers Instalados

- **vtsls** - TypeScript/JavaScript (incluye plugin de Vue)
- **vue_ls** - Vue Language Server (Volar)
- **html** - HTML
- **cssls** - CSS/SCSS/Less
- **emmet_language_server** - Emmet

---

## Formateo de Código

### Atajos

| Atajo | Descripción |
|-------|-------------|
| `Space+f` | Formatear archivo actual manualmente |
| `:w` | Al guardar, formatea automáticamente |

### Configuración

- **Formateador:** Prettier (JS, TS, Vue, CSS, HTML, JSON)
- **Indentación:** 4 espacios
- **Auto-formateo:** Al guardar (`:w`)

### Comandos

```vim
:ConformInfo        " Ver estado del formateador
:Mason              " Instalar/actualizar formateadores
```

---

## Autocompletado (blink.cmp)

### Atajos en Modo Insert

| Atajo | Descripción |
|-------|-------------|
| `Enter` | Aceptar sugerencia |
| `Ctrl+g` | Aceptar sugerencia (alternativo) |
| `Ctrl+Space` | Mostrar menú de completado |
| `Ctrl+e` | Ocultar menú |
| `Ctrl+n` / `↓` | Siguiente sugerencia |
| `Ctrl+p` / `↑` | Sugerencia anterior |
| `Ctrl+b` | Scroll documentación arriba |
| `Ctrl+f` | Scroll documentación abajo |

### Fuentes de Completado

- LSP (funciones, variables, tipos)
- Path (rutas de archivos)
- Snippets (fragmentos de código)
- Buffer (palabras del archivo actual)

---

## Codeium (IA)

Codeium proporciona sugerencias de código completas generadas por IA.

### Atajos en Modo Insert

| Atajo | Descripción |
|-------|-------------|
| `Tab` | Aceptar sugerencia completa |
| `Ctrl+k` | Aceptar siguiente palabra |
| `Ctrl+l` | Aceptar siguiente línea |
| `Ctrl+;` | Siguiente sugerencia alternativa |
| `Ctrl+,` | Sugerencia anterior |
| `Ctrl+x` | Rechazar/limpiar sugerencia |
| `Ctrl+Space` | Activar sugerencia manualmente |

### Comandos

| Atajo | Descripción |
|-------|-------------|
| `Space+cc` | Abrir Codeium Chat |

```vim
:Codeium Auth       " Autenticarse con Codeium
:Codeium Enable     " Habilitar Codeium
:Codeium Disable    " Deshabilitar Codeium
```

### Diferencia con blink.cmp

- **blink.cmp** → Autocompletado LSP preciso (nombres de funciones, variables existentes)
- **Codeium** → Sugerencias IA completas (bloques de código, funciones enteras)

---

## Claude Code (IA)

Asistente de IA integrado en Neovim para ayuda con código.

### Atajos

| Atajo | Descripción |
|-------|-------------|
| `Space+aa` | Abrir/cerrar Claude Code |
| `Space+ac` | Chat con Claude |
| `Space+ar` | Refrescar |
| `Space+as` | Ver estado de conexión |

### Navegación con Claude Code

Cuando Claude Code está abierto:
1. **Abrir Claude:** `Space + a + a`
2. **Ir al chat:** `Ctrl+Shift+l` (derecha)
3. **Volver al código:** `Ctrl+Shift+h` (izquierda)

### Configuración

- **Posición:** Derecha (30% del ancho)
- **Auto-close:** Sí
- **Diff vertical:** Sí

### Comandos

```vim
:ClaudeCode         " Abrir Claude Code
:ClaudeCodeStatus   " Ver estado de conexión
```

### Requisitos

```bash
# Instalar CLI de Claude Code
curl -fsSL claude.ai/install.sh | bash

# Verificar instalación
claude doctor
```

---

## Temas

### Temas Instalados

- **Kanagawa Wave** (por defecto) - Tema japonés claro
- **Kanagawa Dragon** - Variante oscura
- **Catppuccin Mocha** - Tema pastel suave
- **Catppuccin Macchiato** - Variante alternativa
- **Oh-Lucy** - Tema vibrante
- **Oh-Lucy Evening** - Variante nocturna
- **Tokyo Night** - Tema moderno popular

### Atajos para Cambiar Tema

| Atajo | Tema |
|-------|------|
| `Space+tk` | Kanagawa Wave (por defecto) |
| `Space+tK` | Kanagawa Dragon (oscuro) |
| `Space+tc` | Catppuccin Mocha |
| `Space+tC` | Catppuccin Macchiato |
| `Space+tl` | Oh-Lucy |
| `Space+tL` | Oh-Lucy Evening |
| `Space+tt` | Tokyo Night |
| `Space+ts` | Selector interactivo (Telescope) |

### Comandos

```vim
:colorscheme kanagawa-wave
:colorscheme catppuccin
:colorscheme oh-lucy
:Telescope colorscheme      " Selector visual
```

### Cambiar Tema por Defecto

Edita `init.lua` línea 9:
```lua
pcall(vim.cmd.colorscheme, 'kanagawa-wave')  -- Cambia aquí
```

---

## Emmet

### Expandir Abreviaciones

| Atajo | Descripción |
|-------|-------------|
| `Ctrl+e` | Expandir abreviación de Emmet |

### Ejemplos de Uso

```
div.container          → <div class="container"></div>
ul>li*5                → <ul><li></li><li></li>...</ul>
div#header>h1+p        → <div id="header"><h1></h1><p></p></div>
```

**Soportado en:** HTML, Vue, JSX, CSS, SCSS

---

## Comentarios

| Atajo | Descripción |
|-------|-------------|
| `gcc` | Comentar/descomentar línea actual |
| `gc` (modo visual) | Comentar/descomentar selección |
| `gbc` | Comentar en bloque |

---

## Barra de Estado (Statusline)

La barra inferior muestra información importante en todo momento:

### Sección Izquierda
- **Modo actual** - NORMAL, INSERT, VISUAL, COMMAND, etc. (destacado con color)
- **Rama Git** - Rama actual del repositorio
- **Cambios Git** - Líneas añadidas/modificadas/eliminadas
- **Diagnósticos** - Errores y advertencias del LSP

### Sección Central
- **Nombre del archivo** - Archivo actual con estado de modificación

### Sección Derecha
- **Codificación** - UTF-8, etc.
- **Formato de archivo** - unix, dos, mac
- **Tipo de archivo** - javascript, vue, typescript, etc.
- **Progreso** - Porcentaje del archivo
- **Ubicación** - Línea y columna actual

La barra se adapta automáticamente al tema activo.

---

## Explorador de Archivos

### Neo-tree

| Atajo | Descripción |
|-------|-------------|
| `Space+e` | Abrir/cerrar explorador de archivos |

### Oil (Explorador alternativo)

| Atajo | Descripción |
|-------|-------------|
| `-` | Abrir Oil (editar filesystem como buffer) |
| `Ctrl+w w` | Alternar entre Oil y preview |
| `Ctrl+w h/l` | Navegar a ventana izquierda/derecha |

Oil permite editar directorios como si fueran archivos de texto. Usa los comandos estándar de ventanas de Neovim (`Ctrl+w`) para navegar entre Oil y el preview.

---

## Búsqueda (Telescope)

| Atajo | Descripción |
|-------|-------------|
| `Space+ff` | Buscar archivos |
| `Space+fg` | Buscar en contenido (live grep) |
| `Space+fb` | Buscar en buffers abiertos |
| `Space+ts` | Selector de temas |

---

## Git

### Git Signs

Los cambios de Git se muestran en la columna de signos:
- `│` - Línea agregada
- `│` - Línea modificada
- `_` - Línea eliminada
- `~` - Línea cambiada y eliminada

---

## Plugins Instalados

### Gestión de Plugins

- **lazy.nvim** - Gestor de plugins moderno y rápido

### LSP y Autocompletado

- **blink.cmp** - Autocompletado ultra-rápido con LSP
- **friendly-snippets** - Colección de snippets
- **Mason** - Gestor de LSP servers y herramientas
- **mason-tool-installer** - Auto-instalador de herramientas

### IA y Asistentes

- **Codeium** - Autocompletado con IA (gratis)
- **Claude Code** - Asistente de IA en Neovim

### Formateo

- **conform.nvim** - Formateador de código
- **Prettier** - Formateador para JS/TS/Vue/CSS/HTML

### Edición

- **nvim-autopairs** - Auto-cierre de paréntesis, llaves, tags
- **Comment.nvim** - Comentarios inteligentes
- **oil.nvim** - Explorador de archivos editable

### UI y Temas

- **lualine.nvim** - Barra de estado (statusline) con información del modo, git, diagnósticos
- **Kanagawa** - Tema japonés (wave y dragon)
- **Catppuccin** - Tema pastel (mocha y macchiato)
- **Oh-Lucy** - Tema vibrante
- **Tokyo Night** - Tema moderno
- **neo-tree.nvim** - Explorador de archivos en árbol
- **telescope.nvim** - Buscador fuzzy
- **which-key.nvim** - Muestra atajos disponibles
- **gitsigns.nvim** - Indicadores de cambios Git
- **nvim-colorizer.lua** - Muestra colores en CSS
- **snacks.nvim** - Utilidades para terminal

### Lenguajes

- **vim-vue** - Soporte mejorado para Vue.js

---

## Configuración de Archivos

```
~/.config/nvim/
├── init.lua                    # Punto de entrada principal
├── lua/
│   ├── config/
│   │   ├── options.lua         # Opciones generales de Neovim
│   │   ├── keymaps.lua         # Atajos de teclado personalizados
│   │   └── lazy.lua            # Configuración de lazy.nvim
│   └── plugins/
│       ├── lsp.lua             # Configuración de LSP
│       ├── blink-cmp.lua       # Configuración de autocompletado
│       ├── codeium.lua         # Configuración de Codeium
│       ├── claude-code.lua     # Configuración de Claude Code
│       ├── formatter.lua       # Configuración de formateo
│       ├── mason.lua           # Configuración de Mason
│       ├── themes.lua          # Temas de colores
│       ├── oil.lua             # Configuración de Oil
│       └── extras.lua          # Plugins adicionales
├── CLAUDE.md                   # Instrucciones para Claude
└── README.md                   # Este archivo
```

---

## Opciones Configuradas

- **Leader key:** `Space`
- **Números de línea:** Relativos
- **Clipboard:** Integrado con el sistema
- **Indentación:** 4 espacios
- **Búsqueda:** Insensible a mayúsculas (smart case)
- **Swap files:** Deshabilitados
- **Mouse:** Habilitado
- **Colores:** True color (termguicolors)
- **Auto-formateo:** Al guardar con Prettier
- **Wrap:** Activado con ajuste inteligente de líneas
  - `linebreak` - Rompe en palabras completas (no en medio de palabra)
  - `breakindent` - Mantiene indentación en líneas ajustadas
  - `showbreak: '↪ '` - Símbolo visual para líneas continuadas

---

## Soporte para Lenguajes

- ✅ Vue.js (SFC con TypeScript)
- ✅ TypeScript
- ✅ JavaScript (React/JSX)
- ✅ HTML
- ✅ CSS/SCSS/Less
- ✅ JSON/JSONC
- ✅ Lua
- ✅ Markdown

---

## Comandos Útiles de Vim

### Comandos Generales

```vim
:w              " Guardar (y formatear automáticamente)
:q              " Salir
:wq             " Guardar y salir
:q!             " Salir sin guardar
:e archivo      " Abrir archivo
:source %       " Recargar configuración actual
```

### Comandos de Plugins

```vim
:Lazy           " Abrir gestor de plugins
:Lazy sync      " Actualizar todos los plugins
:Mason          " Abrir gestor de LSP servers
:checkhealth    " Verificar estado de Neovim
:LspInfo        " Ver información de LSP activos
:ConformInfo    " Ver estado del formateador
```

---

## Solución de Problemas

### LSP no funciona

```vim
:checkhealth lsp
:LspInfo
:Mason
```

### Formateo no funciona

```vim
:ConformInfo
:Mason          " Instalar Prettier si no está
```

### Codeium no funciona

```vim
:Codeium Auth
:Codeium Enable
```

### Claude Code no conecta

```bash
# En terminal
claude doctor
```

```vim
:ClaudeCodeStatus
```

### Reinstalar plugins

```vim
:Lazy clean
:Lazy sync
```

### Ver logs de LSP

```vim
:lua vim.cmd('e'..vim.lsp.get_log_path())
```

---

## Resumen de Atajos Rápidos

### Los Más Usados

| Atajo | Acción |
|-------|--------|
| `Space+aa` | Abrir Claude Code |
| `Space+ff` | Buscar archivos |
| `Space+e` | Explorador de archivos |
| `Space+f` | Formatear código |
| `Ctrl+Shift+h/l` | Navegar entre ventanas |
| `Shift+h/l` | Navegar entre buffers |
| `Tab` | Aceptar sugerencia Codeium |
| `Ctrl+g` | Aceptar sugerencia blink.cmp |
| `gcc` | Comentar línea |

---

**Hecho con ❤️ para desarrollo con Vue.js, TypeScript y IA**
