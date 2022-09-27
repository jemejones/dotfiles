-------------
-- Aliases --
-------------
local g = vim.g
local fn = vim.fn
local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap

local mappings = {
    {'n', '<leader>e', '<cmd>Telescope find_files<CR>'},
    {'n', '<leader>/',
        '<cmd>lua require\'telescope.builtin\'.live_grep({additional_args = function() return {"--hidden"} end})<CR>'
    },
    {'n', '<leader><localleader>', '<cmd>Telescope grep_string<CR>'},
    {'n', '<leader>"', '<cmd>Telescope registers<CR>'},
    {'n', '<leader>5', '<cmd>norm V$%<CR>'},
    {'n', '<leader>?', '<cmd>Telescope help_tags<CR>'},
    {'n', '<leader>F', '<cmd>NvimTreeFindFile<CR>'},
    {'n', '<leader>G', '<cmd>Telescope git_status<CR>'},
    {'n', '<leader>N', '<cmd>bp<CR>'},
    {'n', '<leader>T', '<cmd>Telescope treesitter<CR>'},
    {'n', '<leader>[', '<cmd>cprev<CR>'}, {'n', '<leader>]', '<cmd>cnext<CR>'},
    {'n', '<leader>a', '<cmd>NvimTreeToggle<CR>'},
    {'n', '<leader>b', '<cmd>Telescope buffers<CR>'},
    {'n', '<leader>f', '<cmd>Telescope git_files<CR>'},
    {'n', '<leader>h', '<cmd>Telescope find_files hidden=true<CR>'},
    {'n', '<leader>n', '<cmd>bn<CR>'},
    {'n', '<leader>sh', '<cmd>split <Bar> ter<CR>'},
    {'n', '<leader>t', '<cmd>Telescope tags<CR>'},
    {'n', '<leader>uc', '<cmd>setlocal cursorcolumn!<CR>'},
    {'n', '<leader>un', '<cmd>setlocal rnu!<CR>'},
    {'n', '<leader>vsh', '<cmd>vsplit <Bar> ter<CR>'},
    {'n', '<leader>x', '<cmd>bd<CR>'},
    {'n', '<localleader>f', '<cmd>Telescope find_files<CR>'},
    {'n', 'gQ', 'mmgggqG\'m'}, -- Comments to keep
    {'n', '<leader>-', 'yypVr-'}, -- headerize with -
    {'t', '<M-h>', '<C-\\><C-n><C-w>h'}, -- per line
    {'t', '<M-j>', '<C-\\><C-n><C-w>j'}, -- when formatting
    {'t', '<M-k>', '<C-\\><C-n><C-w>k'}, -- TODO(mxdevmanuel)
    {'t', '<M-l>', '<C-\\><C-n><C-w>l'}, -- find a better way
    {'t', '<M-n>', '<C-\\><C-n>'}, -- to do this
}

g.mapleader = " "
g.maplocalleader = ","

if fn.maparg('gh', 'n') ~= '' then unmap('n', 'gh') end

if fn.maparg('<C-L>', 'n') == '' then
    map('n', '<C-L>',
        ':nohlsearch<C-R>=has("diff")?"<Bar>diffupdate":""<CR><CR><C-L>', {
        silent = true,
        noremap = true
    })
end

if fn.maparg('<C-L>', 'c') == '' then
    map('c', '<C-L>', '<C-R>=expand("%:p:h") . "/"<CR>', {
        noremap = true
    })
end

for i, v in ipairs(mappings) do
    map(v[1], v[2], v[3], {
        noremap = true,
        silent = true
    })
end

vim.cmd([[
	cnoreabbrev W! w!
	cnoreabbrev Q! q!
	cnoreabbrev Qall! qall!
	cnoreabbrev Wq wq
	cnoreabbrev Wa wa
	cnoreabbrev wQ wq
	cnoreabbrev WQ wq
	cnoreabbrev W w
	cnoreabbrev Q q
	cnoreabbrev Qall qall
	cnoreabbrev wc WriteToClipboard
]])



local opts = { noremap=true, silent=true }
-- vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pylsp', 'gopls' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end
