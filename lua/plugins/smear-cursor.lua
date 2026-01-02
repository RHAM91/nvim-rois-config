return {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
        -- -- Configuración de estela/smear del cursor
        -- smear_between_buffers = true, -- Estela al cambiar entre buffers
        -- smear_between_neighbor_lines = true, -- Estela entre líneas vecinas
        -- scroll_buffer_space = true, -- Permitir scroll con estela
        -- legacy_computing_symbols_support = false, -- Cambiar a true si usas fuentes con símbolos Unicode

        -- -- Estela en modo inserción
        -- smear_insert_mode = true, -- Mostrar estela también en insert mode

        -- -- Configuración de la dinámica de la estela
        -- stiffness = 0.65, -- Rigidez (0-1): más alto = respuesta más rápida
        -- trailing_stiffness = 0.54, -- Rigidez de la estela (0-1): más bajo = estela más larga
        -- damping = 0.6, -- Amortiguación (0-1): controla cuánto rebota/oscila

        -- -- Configuración para insert mode (cursor vertical)
        -- stiffness_insert_mode = 0.6,
        -- damping_insert_mode = 0.8,
        -- distance_stop_animating_vertical_bar = 0.5,

        -- -- Color del cursor (puedes usar un color hex o nombre de grupo de highlight)
        -- -- Usar "none" para que coincida con el color del texto destino
        cursor_color = "#d27e99", -- Color rosa suave (ajusta según tu tema)

        -- -- Color de respaldo para fondos transparentes
        -- transparent_bg_fallback_color = "#1a1b26",

        -- -- Rendimiento: intervalo de tiempo entre dibujos (ms)
        -- -- Valores más bajos = más suave pero más uso de CPU
        -- time_interval = 17, -- ~60fps (17ms)

        -- -- Densidad de la estela
        -- matrix_pixel_threshold = 0.7, -- Controla cuántos "píxeles" se muestran en la estela

        -- -- Ocultar el cursor real mientras se dibuja la estela
        -- hide_target_hack = false, -- Cambiar a true si ves doble cursor
        -- never_draw_over_target = false,
    },
}
