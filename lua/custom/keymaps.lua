-- [[ Keymaps from kickstart.nvim ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Telescope specific keymaps ]]

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>so', require('telescope.builtin').oldfiles, { desc = '[S]earch recently [O]pened files' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Personal keymaps ]]
-- Variable for common options
local n = 'n'
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Basic QOL keymaps
keymap.set(n, '<leader>w', ':w<Return>')
keymap.set(n, '<leader>q', ':q<Return>')

-- Increment/ decrement
keymap.set(n, '+', '<C-a>')
keymap.set(n, '-', '<C-x>')

-- Delete a word backwards
keymap.set(n, 'dbw', 'vb"_d')

-- Select all
keymap.set(n, '<C-a>', 'gg<S-v>G')

-- Disable inherit comment on new line
keymap.set(n, '<Leader>o', 'o<Esc>^Da', opts)
keymap.set(n, '<Leader>O', 'O<Esc>^Da', opts)

-- Tab navigation
keymap.set(n, 'te', ':tabedit')
keymap.set(n, '<tab>', ':tabnext<Return>', opts)
keymap.set(n, '<S-tab>', ':tabprev<Return>', opts)

-- Split window
keymap.set(n, 'ss', ':split<Return>', opts)
keymap.set(n, 'sv', ':vsplit<Return>', opts)

-- Window navigation
keymap.set(n, '<C-h>', '<C-w>h')
keymap.set(n, '<C-j>', '<C-w>j')
keymap.set(n, '<C-k>', '<C-w>k')
keymap.set(n, '<C-l>', '<C-w>l')

-- Window resizing
keymap.set(n, '<C-left>', '<C-w><')
keymap.set(n, '<C-right>', '<C-w>>')
keymap.set(n, '<C-up>', '<C-w>+')
keymap.set(n, '<C-down>', '<C-w>-')

-- Buffer navigation
keymap.set(n, '<S-h>', ':bprev<Return>')
keymap.set(n, '<S-l>', ':bnext<Return>')

-- Override diagnostic keymaps
keymap.set(n, ';d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
keymap.set(n, ';D', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
keymap.set(n, '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
keymap.set(n, '<leader>K', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
