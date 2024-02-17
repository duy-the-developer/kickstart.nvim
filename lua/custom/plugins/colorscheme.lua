return {
  { 'rktjmp/lush.nvim' },
  { 'metalelf0/jellybeans-nvim' },
  { 'navarasu/onedark.nvim' },
  { 'folke/tokyonight.nvim' },
  {
    'Shatur/neovim-ayu',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'ayu-dark'
    end,
  }
}
