return {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    init = function()
        -- Configuración de vim-visual-multi
        -- Esta función se ejecuta antes de cargar el plugin

        -- Desactivar mapeos por defecto si quieres personalizar
        -- vim.g.VM_default_mappings = 0

        -- Personalizar teclas (opcional, comentado por defecto)
        -- vim.g.VM_maps = {
        --     ["Find Under"] = "<C-n>",           -- Seleccionar palabra bajo cursor
        --     ["Find Subword Under"] = "<C-n>",   -- Seleccionar subpalabra
        --     ["Select All"] = "\\A",             -- Seleccionar todas las ocurrencias
        --     ["Start Regex Search"] = "\\/",     -- Búsqueda con regex
        --     ["Add Cursor Down"] = "<C-Down>",   -- Añadir cursor abajo
        --     ["Add Cursor Up"] = "<C-Up>",       -- Añadir cursor arriba
        --     ["Add Cursor At Pos"] = "\\\\",     -- Añadir cursor en posición
        --     ["Visual Cursors"] = "\\c",         -- Crear cursores desde selección visual
        --     ["Visual All"] = "\\A",             -- Seleccionar todo visualmente
        --     ["Visual Regex"] = "\\/",           -- Regex en modo visual
        --     ["Visual Find"] = "\\f",            -- Buscar en modo visual
        --     ["Visual Add"] = "\\a",             -- Añadir en modo visual
        --     ["Skip Region"] = "q",              -- Saltar región actual
        --     ["Remove Region"] = "Q",            -- Remover región actual
        --     ["Increase"] = "+",                 -- Aumentar selección
        --     ["Decrease"] = "_",                 -- Disminuir selección
        --     ["Invert"] = "o",                   -- Invertir selección
        --     ["Next"] = "n",                     -- Siguiente ocurrencia
        --     ["Prev"] = "N",                     -- Anterior ocurrencia
        --     ["Goto Next"] = "]",                -- Ir al siguiente cursor
        --     ["Goto Prev"] = "[",                -- Ir al cursor anterior
        --     ["Seek Next"] = "<C-f>",            -- Buscar siguiente
        --     ["Seek Prev"] = "<C-b>",            -- Buscar anterior
        --     ["Skip Next"] = "<C-x>",            -- Saltar siguiente
        --     ["Skip Prev"] = "<C-p>",            -- Saltar anterior
        --     ["Remove Last Region"] = "<C-z>",   -- Remover última región
        --     ["Surround"] = "S",                 -- Rodear con caracteres
        --     ["Replace Pattern"] = "R",          -- Reemplazar patrón
        -- }

        -- Tema de los cursores (opcional)
        -- vim.g.VM_theme = 'ocean'  -- Opciones: 'default', 'iceblue', 'ocean', 'sand', 'purplegray', 'codedark'

        -- Configurar highlight de los cursores
        vim.g.VM_highlight_matches = "underline" -- Opciones: 'underline', 'hi'

        -- Mostrar mensaje de bienvenida (0 = no mostrar)
        vim.g.VM_show_warnings = 0
    end,
    config = function()
        -- Notas sobre uso:
        --
        -- TECLAS PRINCIPALES:
        -- Ctrl+n       - Seleccionar palabra bajo cursor (presiona repetidamente para más ocurrencias)
        -- Ctrl+Down/Up - Crear cursores verticalmente
        -- n/N          - Siguiente/anterior ocurrencia (en modo multicursor)
        -- [/]          - Navegar entre cursores
        -- q            - Saltar ocurrencia actual
        -- Q            - Remover cursor actual
        -- Tab          - Alternar entre modo Cursor y modo Extend
        -- i/a/I/A      - Entrar en modo inserción en todos los cursores
        -- Esc          - Salir del modo multicursor
        --
        -- MODO EXTEND vs MODO CURSOR:
        -- - Cursor Mode: Comandos normales de Vim
        -- - Extend Mode: Comandos como en modo visual
        -- - Tab para alternar entre ellos
        --
        -- COMANDOS ÚTILES:
        -- \\A          - Seleccionar todas las ocurrencias de la palabra
        -- \\/          - Búsqueda con regex
        -- \\\\         - Añadir cursor en posición actual
        -- c, d, y      - Cambiar, borrar, copiar en todos los cursores
        -- r            - Reemplazar carácter en todos los cursors
        -- ~            - Cambiar mayúsculas/minúsculas
    end,
}
