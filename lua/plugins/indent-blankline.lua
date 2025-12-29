return {
	"echasnovski/mini.indentscope",
	version = false,
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		-- Símbolo para la línea del scope
		symbol = "│", -- Línea vertical
		-- symbol = "▏", -- Alternativa: más delgada
		-- symbol = "┃", -- Alternativa: más gruesa

		-- Opciones de dibujado
		options = {
			border = "top", -- Muestra borde arriba ('top', 'bottom', 'both', 'none')
			indent_at_cursor = true, -- Dibuja basado en la posición del cursor
			try_as_border = true, -- Intenta dibujar como borde completo
		},

		-- Dibujar en qué eventos
		draw = {
			delay = 0, -- Sin delay para respuesta inmediata
			animation = function()
				return 0 -- Sin animación (puedes poner 20 para animación suave)
			end,
			-- Prioridad alta para asegurar que se dibuje
			priority = 2,
		},

		-- Mapeos (deshabilitados para evitar conflictos)
		mappings = {
			object_scope = "", -- Deshabilita el text object
			object_scope_with_border = "",
			goto_top = "", -- Deshabilita navegación por scope
			goto_bottom = "",
		},
	},
	config = function(_, opts)
		require("mini.indentscope").setup(opts)

		-- Personalizar el color del scope
		vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {
			--fg = "#bb9af7", -- Color púrpura/violeta (ajústalo a tu gusto)
			-- Otras opciones de color:
			-- fg = "#7aa2f7", -- Azul
			-- fg = "#9ece6a", -- Verde
			 fg = "#ff9e64", -- Naranja
			-- fg = "#f7768e", -- Rojo/Rosa
		})

		-- Deshabilitar en ciertos tipos de archivo
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
				"oil",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
