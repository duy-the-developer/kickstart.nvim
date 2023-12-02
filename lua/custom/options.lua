print("hello from options.lua")

-- [[ Options from kickstart.nvim ]]
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Personal options ]]
-- Re-Enable highlight search
vim.o.hlsearch = false

-- Use relative line number
vim.o.relativenumber = true

-- Indentation
vim.o.breakindent = true -- Visually indent wrapped lines
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true

-- Soy dev indents
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- No wrap lines
vim.o.wrap = false

-- Display filename
vim.o.title = true

-- Disable mouse 
vim.o.mouse = ''

-- Split new windows below or right of current
vim.o.splitbelow = true
vim.o.splitright = true

-- Keep text on the same screen line after splitting
vim.o.splitkeep = "screen"

-- Scrolling margin
vim.o.scrolloff = 12
vim.o.sidescrolloff = 12
