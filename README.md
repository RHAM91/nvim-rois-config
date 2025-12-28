# 🚀 Configuración de Neovim

Configuración completa de Neovim optimizada para desarrollo con Vue.js, TypeScript y JavaScript.

## 📋 Tabla de Contenidos

- [Instalación](#instalación)
- [Leader Key](#leader-key)
- [Navegación](#navegación)
- [Buffers](#buffers)
- [Edición](#edición)
- [Modo Visual](#modo-visual)
- [LSP (Language Server Protocol)](#lsp-language-server-protocol)
- [Emmet](#emmet)
- [Comentarios](#comentarios)
- [Explorador de Archivos](#explorador-de-archivos)
- [Búsqueda (Telescope)](#búsqueda-telescope)
- [Ventanas](#ventanas)
- [Git](#git)
- [Plugins Instalados](#plugins-instalados)

---

## Instalación

1. Clona este repositorio en tu directorio de configuración:
```bash
git clone <tu-repo> ~/.config/nvim
```

2. Abre Neovim y los plugins se instalarán automáticamente:
```bash
nvim
```

3. Instala los LSP servers (si no se instalan automáticamente):
```vim
:Mason
```

---

## Leader Key

La tecla **Leader** está configurada como **`Espacio`** (Space).

---

## Navegación

### Navegación Básica

| Atajo | Descripción |
|-------|-------------|
| `h` `j` `k` `l` | Izquierda, Abajo, Arriba, Derecha |
| `w` | Siguiente palabra |
| `b` | Palabra anterior |
| `e` | Final de palabra |
| `0` | Inicio de línea |
| `$` | Final de línea |
| `gg` | Inicio del archivo |
| `G` | Final del archivo |

### Navegación entre Párrafos

| Atajo | Descripción |
|-------|-------------|
| `Shift+j` | Bajar al siguiente párrafo (línea en blanco) |
| `Shift+k` | Subir al anterior párrafo (línea en blanco) |
| `{` | Subir al anterior párrafo (alternativo) |
| `}` | Bajar al siguiente párrafo (alternativo) |

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

### Comandos Directos

```vim
:bd          " Cerrar buffer actual
:bd!         " Cerrar buffer sin guardar
:bd 3        " Cerrar buffer número 3
:buffers     " Ver lista de buffers
:ls          " Ver lista de buffers (alternativo)
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
| `Ctrl+k` | Ayuda de firma de función |

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
| `Space+f` | Formatear código |

### LSP Servers Instalados

- **vtsls** - TypeScript/JavaScript
- **vue_ls** - Vue.js (anteriormente Volar)
- **html** - HTML
- **cssls** - CSS/SCSS/Less
- **emmet_language_server** - Emmet

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

## Explorador de Archivos

### Neo-tree

| Atajo | Descripción |
|-------|-------------|
| `Space+e` | Abrir/cerrar explorador de archivos |

### Oil (Explorador alternativo)

Oil permite editar directorios como si fueran archivos de texto.

---

## Búsqueda (Telescope)

| Atajo | Descripción |
|-------|-------------|
| `Space+ff` | Buscar archivos |
| `Space+fg` | Buscar en contenido (live grep) |
| `Space+fb` | Buscar en buffers abiertos |

---

## Ventanas

### Navegación entre Ventanas

| Atajo | Descripción |
|-------|-------------|
| `Ctrl+h` | Ir a ventana izquierda |
| `Ctrl+j` | Ir a ventana abajo |
| `Ctrl+k` | Ir a ventana arriba |
| `Ctrl+l` | Ir a ventana derecha |

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

- **lazy.nvim** - Gestor de plugins moderno

### LSP y Autocompletado

- **mason.nvim** - Gestor de LSP servers
- **mason-lspconfig.nvim** - Integración con lspconfig
- **nvim-lspconfig** - Configuración de LSP
- **blink.cmp** - Autocompletado inteligente

### Edición

- **nvim-autopairs** - Auto-cierre de paréntesis, llaves, tags HTML
- **Comment.nvim** - Comentarios inteligentes
- **oil.nvim** - Explorador de archivos

### UI

- **neo-tree.nvim** - Explorador de archivos en árbol
- **telescope.nvim** - Buscador fuzzy
- **which-key.nvim** - Muestra atajos disponibles
- **gitsigns.nvim** - Indicadores de cambios Git
- **nvim-colorizer.lua** - Muestra colores en CSS

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
│       ├── oil.lua             # Configuración de Oil
│       └── extras.lua          # Plugins adicionales
└── README.md                   # Este archivo
```

---

## Opciones Configuradas

- **Leader key:** `Space`
- **Números de línea:** Relativos
- **Clipboard:** Integrado con el sistema
- **Tabs:** 2 espacios
- **Búsqueda:** Insensible a mayúsculas (smart case)
- **Swap files:** Deshabilitados
- **Mouse:** Habilitado
- **Colores:** True color (termguicolors)

---

## Soporte para Lenguajes

- ✅ Vue.js (SFC)
- ✅ TypeScript
- ✅ JavaScript (React)
- ✅ HTML
- ✅ CSS/SCSS/Less
- ✅ JSON

---

## Comandos Útiles de Vim

### Comandos Generales

```vim
:w              " Guardar
:q              " Salir
:wq             " Guardar y salir
:q!             " Salir sin guardar
:e archivo      " Abrir archivo
:source %       " Recargar configuración actual
```

### Comandos de Plugins

```vim
:Lazy           " Abrir gestor de plugins
:Mason          " Abrir gestor de LSP servers
:checkhealth    " Verificar estado de Neovim
:LspInfo        " Ver información de LSP activos
```

---

## Solución de Problemas

### LSP no funciona

```vim
:checkhealth lsp
:LspInfo
:Mason
```

### Reinstalar plugins

```vim
:Lazy clean
:Lazy install
```

### Ver logs de LSP

```vim
:lua vim.cmd('e'..vim.lsp.get_log_path())
```

---

## Contribuir

Si encuentras algún problema o tienes sugerencias, no dudes en abrir un issue.

---

## Licencia

MIT License - Usa y modifica libremente esta configuración.

---

**Hecho con ❤️ para desarrollo con Vue.js y TypeScript**
