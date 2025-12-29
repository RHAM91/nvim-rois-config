return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit (root dir)' },
    { '<leader>gG', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit (current file)' },
    { '<leader>gc', '<cmd>LazyGitFilter<cr>', desc = 'LazyGit Commits' },
    { '<leader>gf', '<cmd>LazyGitFilterCurrentFile<cr>', desc = 'LazyGit File History' },
  },
  config = function()
    -- Configuración de lazygit
    vim.g.lazygit_floating_window_winblend = 0 -- Transparencia de la ventana (0-100)
    vim.g.lazygit_floating_window_scaling_factor = 0.9 -- Tamaño de la ventana flotante (0-1)
    vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'} -- Bordes redondeados
    vim.g.lazygit_floating_window_use_plenary = 0 -- Usar ventana flotante nativa de Neovim
    vim.g.lazygit_use_neovim_remote = 1 -- Usar neovim-remote para editar archivos

    -- Usar el tema del terminal
    vim.g.lazygit_use_custom_config_file_path = 0
  end,
}
