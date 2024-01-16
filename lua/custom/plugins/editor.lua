return {
  -- Git related plugins
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  --
  -- Detect tabstop and shiftwidth automatically
  -- { 'tpope/vim-sleuth' },
  --
  -- 'nvim-telescope/telescope.nvim'
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
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
    },
    config = function()
      require('telescope').setup {
        defaults = {
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
          },
        },
      }
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
      vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
      vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
      vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

			require('neo-tree').setup {
				default_component_configs = {
					indent = {
						-- indent guides
						indent_marker = '│',
						last_indent_marker = '└',
						highlight = 'NeoTreeIndentMarker',
						-- expander config, needed for nesting files
						with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
						expander_collapsed = '',
						expander_expanded = '',
						expander_highlight = 'NeoTreeExpander',
					},
					name = {
						trailing_slash = true,
						use_git_status_colors = true,
						highlight = 'NeoTreeFileName',
					},
					git_status = {
						symbols = {
							-- Change type
							added = '✚', -- or "✚", but this is redundant info if you use git_status_colors on the name
							modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
						},
					},
					-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
					file_size = {
						enabled = true,
						required_width = 64, -- min width of window required to show this column
					},
					type = {
						enabled = true,
						required_width = 122, -- min width of window required to show this column
					},
					last_modified = {
						enabled = true,
						required_width = 88, -- min width of window required to show this column
					},
					created = {
						enabled = true,
						required_width = 110, -- min width of window required to show this column
					},
					symlink_target = {
						enabled = false,
					},
				},
				-- A list of functions, each representing a global custom command
				-- that will be available in all sources (if not overridden in `opts[source_name].commands`)
				-- see `:h neo-tree-custom-commands-global`
				commands = {},
				window = {
					position = 'left',
					width = 40,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						['<space>'] = {},
						['c'] = 'close_node',
						['C'] = 'close_all_subnodes',
						['z'] = 'close_all_nodes',
						['Z'] = 'expand_all_nodes',
					},
				},
				filesystem = {
					filtered_items = {
						visible = false, -- when true, they will just be displayed differently than normal items
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_hidden = false, -- only works on Windows for hidden files/directories
					},
					follow_current_file = {
						enabled = true, -- This will find and focus the file in the active buffer every time
						--               -- the current file is changed while the tree is open.
					},
					-- "open_current", -- netrw disabled, opening a directory opens neo-tree
					-- in whatever position is specified in window.position
					hijack_netrw_behavior = 'open_current', -- netrw disabled, opening a directory opens within the
					-- window like netrw would, regardless of window.position
					-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
				},
			}

			vim.keymap.set('n', '<leader>e', ':Neotree toggle<Return>', { silent = true, desc = 'N[e]otree toggle' })
		end,
	},
	{
		'RRethy/vim-illuminate',
		config = function()
			require('illuminate').configure {}
			vim.api.nvim_set_hl(0, 'IlluminatedWordText', { underline = true })
			vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { underline = true })
			vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { underline = true })
			--- auto update the highlight style on colorscheme change
			vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
				pattern = { '*' },
				callback = function(_)
					vim.api.nvim_set_hl(0, 'IlluminatedWordText', { underline = true })
					vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { underline = true })
					vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { underline = true })
				end,
			})
		end,
	},
	{
		'echasnovski/mini.bufremove',
		version = false, -- install the default recommended `main` branch
		config = function()
			require('mini.bufremove').setup {}
		end,
		keys = {
			{
				'<leader>bd',
				function()
					local bd = require('mini.bufremove').delete
					if vim.bo.modified then
						local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
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
				desc = 'Delete Buffer',
			},
			-- stylua: ignore
			{ "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    'kdheepak/lazygit.nvim',
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opt = {
      lazygit_floating_window_winblend = 0,
      lazygit_floating_window_scaling_factor = 0.9,
      lazygit_floating_window_border_chars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      lazygit_floating_window_use_plenary = 1,
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<CR>', desc = 'Lazy[G]it' },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = {
      'MarkdownPreview',
      'MarkdownPreviewStop',
      'MarkdownPreviewToggle',
    },
    build = 'cd app && yarn install',
    init = function()
      vim.g.makdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  {
    'norcalli/nvim-colorizer.lua',
    opt = {},
  },
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',
    },
    opts = {
      workspaces = {
        {
          name = 'personal',
          path = '~/p/notes',
        },
      },
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ''
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. '-' .. suffix
      end,
    },
  },
}
