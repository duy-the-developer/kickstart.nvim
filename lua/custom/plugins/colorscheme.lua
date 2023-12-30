return {
  { 'rktjmp/lush.nvim' },
  { 'metalelf0/jellybeans-nvim' },
  { 'navarasu/onedark.nvim' },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'jellybeans-nvim'
    end,
  },
}
