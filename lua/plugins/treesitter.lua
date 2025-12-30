return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false, -- Cargar inmediatamente para asegurar que se instale
	priority = 100, -- Alta prioridad para cargar antes que hlchunk
	config = function()
		-- Usar la API correcta de nvim-treesitter
		require("nvim-treesitter").setup({
			-- Instalar parsers solo para los lenguajes que usas
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"javascript",
				"typescript",
				"vue",
				"html",
				"css",
				"json",
				"python",
				"markdown",
				"markdown_inline",
			},

			-- Instalar parsers de forma sincrónica para asegurar que se instalen
			sync_install = true,

			-- Instalar automáticamente parsers faltantes al abrir archivos
			auto_install = true,

			-- Highlighting (deshabilitado para evitar conflictos con tu sintaxis actual)
			highlight = {
				enable = false, -- Cambiar a true si quieres syntax highlighting de Treesitter
				-- Deshabilitar en archivos grandes para mejor rendimiento
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				-- No usar vim regex highlighting en conjunto con Treesitter
				additional_vim_regex_highlighting = false,
			},

			-- Indentación basada en Treesitter (deshabilitada para mantener tu config actual)
			indent = {
				enable = false,
			},

			-- Incrementar selección basada en nodos de Treesitter (opcional)
			incremental_selection = {
				enable = false,
			},
		})
	end,
}
