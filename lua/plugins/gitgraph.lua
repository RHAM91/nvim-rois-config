-- ~/.config/nvim/lua/plugins/gitgraph.lua
-- Visualizador gráfico de historial de Git

return {
  'isakbm/gitgraph.nvim',
  -- Lazy loading: solo cargar cuando se use
  cmd = { 'GitGraph' },
  dependencies = { 'sindrets/diffview.nvim' }, -- Opcional: para ver diffs de commits
  opts = {
    -- Símbolos para representar el gráfico de Git
    symbols = {
      -- Símbolos básicos para commits
     merge_commit = '',
    commit = '',
    merge_commit_end = '',
    commit_end = '', 

      -- Símbolos avanzados Kitty (Unicode Private Use Area 0xf5d0-0xf5fb)
      -- Estos símbolos están diseñados específicamente para gráficos Git
      -- Soportados por Kitty, Ghostty, y otros terminales modernos
     GVER = '',
    GHOR = '',
    GCLD = '',
    GCRD = '╭',
    GCLU = '',
    GCRU = '',
    GLRU = '',
    GLRD = '',
    GLUD = '',
    GRUD = '',
    GFORKU = '',
    GFORKD = '',
    GRUDCD = '',
    GRUDCU = '',
    GLUDCD = '',
    GLUDCU = '',
    GLRDCL = '',
    GLRDCR = '',
    GLRUCL = '',
    GLRUCR = '', 
    },

    -- Formato de la información mostrada
    format = {
      timestamp = '%Y-%m-%d %H:%M:%S', -- Formato de fecha y hora
      fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' }, -- Campos a mostrar
    },

    -- Hooks para interactuar con commits
    hooks = {
      -- Ejecutar cuando se selecciona un commit (presionar Enter)
      on_select_commit = function(commit)
        -- Integración con diffview.nvim para ver el diff del commit
        vim.notify('Abriendo diff del commit: ' .. commit.hash, vim.log.levels.INFO)
        vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
      end,

      -- Ejecutar cuando se selecciona un rango de commits (modo visual + Enter)
      on_select_range_commit = function(from, to)
        -- Ver diff entre dos commits
        vim.notify('Abriendo diff desde ' .. from.hash .. ' hasta ' .. to.hash, vim.log.levels.INFO)
        vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
      end,
    },
  },

  keys = {
    {
      '<leader>gh',
      function()
        require('gitgraph').draw({}, { all = true, max_count = 5000 })
      end,
      desc = 'GitGraph: Ver historial gráfico de Git',
    },
  },

  -- Configuración adicional después de cargar el plugin
  config = function(_, opts)
    require('gitgraph').setup(opts)

    -- Configurar colores personalizados para las ramas (opcional)
    -- Puedes ajustar estos colores según tu tema
    vim.api.nvim_set_hl(0, 'GitGraphHash', { fg = '#ff9e64' }) -- Naranja (estilo kanagawa)
    vim.api.nvim_set_hl(0, 'GitGraphTimestamp', { fg = '#7aa2f7' }) -- Azul
    vim.api.nvim_set_hl(0, 'GitGraphAuthor', { fg = '#9ece6a' }) -- Verde
    vim.api.nvim_set_hl(0, 'GitGraphBranchName', { fg = '#bb9af7' }) -- Púrpura
    vim.api.nvim_set_hl(0, 'GitGraphBranchTag', { fg = '#f7768e' }) -- Rojo
    vim.api.nvim_set_hl(0, 'GitGraphBranchMsg', { fg = '#c0caf5' }) -- Blanco azulado

    -- Colores para las diferentes ramas (hasta 5 colores diferentes)
    vim.api.nvim_set_hl(0, 'GitGraphBranch1', { fg = '#7aa2f7' }) -- Azul
    vim.api.nvim_set_hl(0, 'GitGraphBranch2', { fg = '#bb9af7' }) -- Púrpura
    vim.api.nvim_set_hl(0, 'GitGraphBranch3', { fg = '#9ece6a' }) -- Verde
    vim.api.nvim_set_hl(0, 'GitGraphBranch4', { fg = '#ff9e64' }) -- Naranja
    vim.api.nvim_set_hl(0, 'GitGraphBranch5', { fg = '#f7768e' }) -- Rojo
  end,
}
