return {
	-- "b0o/incline.nvim",
    -- event = "BufReadPre", -- Load this plugin before reading a buffer
    -- priority = 1200, -- Set the priority for loading this plugin
    -- config = function()
    --   require("incline").setup({
    --     window = { margin = { vertical = 0, horizontal = 1 } }, -- Set the window margin
    --     hide = {
    --       cursorline = true, -- Hide the incline window when the cursorline is active
    --     },
    --     render = function(props)
    --       local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t") -- Get the filename
    --       if vim.bo[props.buf].modified then
    --         filename = "[+] " .. filename -- Indicate if the file is modified
    --       end

    --       local icon, color = require("nvim-web-devicons").get_icon_color(filename) -- Get the icon and color for the file
    --       return { { icon, guifg = color }, { " " }, { filename } } -- Return the rendered content
    --     end,
    --   })
    -- end,
	'b0o/incline.nvim',
	-- Optimizar en modo bajo recurso (usa rendering más simple)
	event = 'VeryLazy',
	config = function()
		local incline = require('incline')
		local bajo_recurso = vim.g.activar_modo_bajo_recurso or false

		incline.setup({
			window = {
				padding = 0,
				margin = {
					horizontal = 1,
					vertical = 1,
				},
				placement = {
					horizontal = 'right', -- Esquina derecha
					vertical = 'top',     -- Parte superior
				},
				zindex = 50,              -- Por encima de todo
				winhighlight = {
					active = {
						Normal = 'InclineNormal',
						NormalNC = 'InclineNormalNC'
					},
					inactive = {
						Normal = 'InclineNormalNC',
						NormalNC = 'InclineNormalNC'
					}
				},
			},
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
				if filename == '' then
					filename = '[Sin nombre]'
				end

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

				-- Nombre del archivo
				table.insert(result, { filename })

				-- Indicador de modificado
				if modified then
					table.insert(result, { ' ● ', guifg = '#ff9e64' })
				else
					table.insert(result, { ' ' })
				end

				return result
			end,
			hide = {
				cursorline = false, -- No ocultar cuando el cursor está en la línea
			},
		})

		-- Definir colores personalizados para incline
		vim.api.nvim_set_hl(0, 'InclineNormal', { bg = '#2a2a37', fg = '#c0caf5', bold = true })
		vim.api.nvim_set_hl(0, 'InclineNormalNC', { bg = '#1f1f28', fg = '#727169' })
	end,
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	}
}
