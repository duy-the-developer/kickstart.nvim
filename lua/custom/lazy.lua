-- Set leader before plugins are required (otherwise wrong leader will be used) 
vim.g.mapleader = ' '
vim.g.maplocalleader= ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Default Lazy.nvim settings 
require("lazy").setup({
	-- defaults = {
	-- 	-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
	-- 	-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
	-- 	lazy = false,
	-- 	-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
	-- 	-- have outdated releases, which may break your Neovim install.
	-- 	version = false, -- always use the latest git commit
	-- 	-- version = "*", -- try installing the latest stable version for plugins that support semver
	-- },
	-- dev = {
	-- 	path = "~/.ghq/github.com",
	-- },
	-- checker = { enabled = true }, -- automatically check for plugin updates
	-- performance = {
	-- 	cache = {
	-- 		enabled = true,
	-- 		-- disable_events = {},
	-- 	},
	-- 	rtp = {
	-- 		-- disable some rtp plugins
	-- 		disabled_plugins = {
	-- 			"gzip",
	-- 			-- "matchit",
	-- 			-- "matchparen",
	-- 			"netrwPlugin",
	-- 			"rplugin",
	-- 			"tarPlugin",
	-- 			"tohtml",
	-- 			"tutor",
	-- 			"zipPlugin",
	-- 		},
	-- 	},
	-- },
	-- Import custom plugins from `lua/custom/plugins/*`
	spec = {
		{ import = "custom.plugins" },
	},
})
