local on_attach = function(_, bufnr)
  -- local toggleInlay = function()
  --   if _.server_capabilities.inlayHintProvider then
  --     local current_value = vim.lsp.inlay_hint.get({ bufnr = 0 })[1]
  --     vim.lsp.inlay_hint.enable(bufnr, not current_value)
  --   end
  -- end

  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.

  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  -- nmap('<leader>ti', toggleInlay, 'toggle inlay hint')
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-S-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {},
  rust_analyzer = {},
  tsserver = {},
  html = {},
  -- eslint = {},
  jsonls = {},
  volar = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
  apex_ls = {
    filetypes = { 'apex', 'visualforce', 'lightning', 'cls', 'st' },
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {}
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      {
        'folke/neodev.nvim',
        opts = {}
      },
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup()
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }
        end,
      }

      -- `mason_lspconfig.setup_handlers` doesn't handle apex_ls automaticlally (why not?), we need to manually attach below actions
      local lspconfig = require 'lspconfig'
      lspconfig.apex_ls.setup {
        apex_enable_semantic_errors = false,
        apex_enable_completion_statistics = false,
        filetypes = { 'apex' },
        root_dir = lspconfig.util.root_pattern('sfdx-project.json'),

        on_attach = on_attach,
        capabilities = capabilities,
      }
    end,
  },
}
