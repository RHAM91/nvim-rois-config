return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false, -- Este plugin no soporta lazy-loading
	priority = 100, -- Alta prioridad para cargar antes que hlchunk
	config = function()
		-- Instalar parsers necesarios
		local parsers = {
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

		-- Instalar parsers automáticamente
		local ok, ts = pcall(require, 'nvim-treesitter')
		if ok then
			ts.install(parsers)
		end

		-- OPTIMIZACIÓN: No iniciar Treesitter automáticamente en cada buffer
		-- Se inicia lazy cuando sea necesario (mejora rendimiento en WSL)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "vue", "javascript", "typescript", "html", "css", "lua" },
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
