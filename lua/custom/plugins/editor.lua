return {
	--
	-- Git related plugins
	{ 'tpope/vim-fugitive' },
	{ 'tpope/vim-rhubarb' },
	--
	-- Detect tabstop and shiftwidth automatically
	-- { 'tpope/vim-sleuth' },
	--
	-- 'nvim-telescope/telescope.nvim'
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
		}
	},
	{
		'RRethy/vim-illuminate',
		config = function ()
			require('illuminate').configure({})
			vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
			vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
			vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
			--- auto update the highlight style on colorscheme change 
			vim.api.nvim_create_autocmd(
				{ "ColorScheme" },
				{ pattern = { "*" },
				callback = function(_)
					vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
					vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
					vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
				end
			})
		end
	},
	{
		'echasnovski/mini.bufremove',
		version = false, -- install the default recommended `main` branch
		config = function()
			require('mini.bufremove').setup({})
		end,
		keys = {
			{
				"<leader>bd",
				function()
					local bd = require("mini.bufremove").delete
					if vim.bo.modified then
						local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
						if choice == 1 then -- Yes
							vim.cmd.write()
							bd(0)
						elseif choice == 2 then -- No
							bd(0, true)
						end
					else
						bd(0)
					end
				end,
				desc = "Delete Buffer",
			},
			-- stylua: ignore
			{ "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
		}
	},
}
