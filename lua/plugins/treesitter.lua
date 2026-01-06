return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false, -- Este plugin no soporta lazy-loading
	priority = 100, -- Alta prioridad para cargar antes que hlchunk
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
			"lua",
			"vim",
			"vimdoc",
			"javascript",
			"typescript",
			"vue", -- CRÍTICO para comentarios contextuales en archivos Vue
			"html",
			"css",
			"json",
			"python",
			"markdown",
			"markdown_inline",
		}

		-- Seleccionar lista de parsers según el modo
		local parsers = bajo_recurso and parsers_bajo_recurso or parsers_completos

		-- Instalar parsers automáticamente
		local ok, ts = pcall(require, 'nvim-treesitter')
		if ok then
			ts.install(parsers)
		end

		-- Habilitar highlighting solo cuando sea necesario
		-- En modo bajo recurso, limitar a Vue (necesario para comentarios)
		local filetypes = bajo_recurso
			and { "vue" }
			or { "vue", "javascript", "typescript", "html", "css", "lua" }

		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
