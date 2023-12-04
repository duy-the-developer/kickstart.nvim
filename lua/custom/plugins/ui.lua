return {
  -- folke/which-key.nvim
  { 'folke/which-key.nvim', opts = {} },

  -- lewis6991/gitsigns.nvim
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  -- nvim-lualine/lualine.nvim
  {
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = false,
        globalstatus = true,
        disabled_filetypes = {
          statusline = {
            'neo-tree',
          },
          tabline = {
            'neo-tree',
          },
          winbar = {
            'neo-tree',
          },
        },
      },
      sections = {
        lualine_z = { 'datetime' },
      },
      tabline = {
        lualine_c = {
          {
            'buffers',
            show_filename_only = false,
            mode = 4,
            disabled_buftypes = { 'quickfix', 'prompt' },
          },
        },
        lualine_x = {
          { 'tabs' },
        },
      },
      winbar = {
        lualine_b = { 'filename' },
      },
      inactive_winbar = {
        lualine_c = { 'filename' },
      },
    },
  },

  -- 'lukas-reineke/indent-blankline.nvim'
  -- {
  --   -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   -- Enable `lukas-reineke/indent-blankline.nvim`
  --   -- See `:help ibl`
  --   main = 'ibl',
  --   opts = {},
  -- },
  --
  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  {
    'echasnovski/mini.indentscope',
    version = false,
    config = function()
      local indentscope = require 'mini.indentscope'
      indentscope.setup {
        draw = {
          delay = 0,
          animation = indentscope.gen_animation.none(),
        },
        symbol = '▏',
        options = { try_as_border = true },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
