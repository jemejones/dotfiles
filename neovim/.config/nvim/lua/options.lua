-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local env = vim.env -- environment variables
local fn = vim.fn -- call Vim functions
local g = vim.g -- global variables
local o = vim.o -- global options
local w = vim.wo -- windows-scoped options
local opt = vim.opt -- table options (TODO: wanna know difference with `o`)

w.number = true
w.relativenumber = true
w.signcolumn = 'yes:1'
w.cursorline = false
w.colorcolumn = '99999'
w.foldmethod = 'expr'
w.foldexpr = 'nvim_tressiter#foldexpr()'

o.autoread = true
o.foldlevelstart = 20
o.hidden = true
o.hlsearch = true
o.inccommand = 'nosplit'
o.incsearch = true
o.laststatus = 2
o.lazyredraw = true
o.mouse = 'a'
o.mousemodel = 'popup'
o.pastetoggle = '<F11>'
o.scrolloff = 3
o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,globals"
o.showcmd = true
o.showmatch = true
o.showmode = true
o.smarttab = true
o.smartindent = true
o.splitbelow = true
o.splitright = true
o.syntax = 'enable'
o.termguicolors = true
o.updatetime = 300

if fn.executable("rg") == 1 then
    o.grepprg = 'rg --vimgrep --no-heading --hidden --glob=\'!.git/\''
    o.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

if fn.has('mouse_sgr') ~= 0 then o.ttymouse = 'sgr' end

local undodir = "/tmp/.vim-undo-dir"
if fn.isdirectory(undodir) == 0 then fn.mkdir(undodir, "", 0755) end
o.undodir = undodir
o.undofile = true

-- correct
local swapdir = "/tmp/.vim-swap-dir"
if fn.isdirectory(swapdir) == 0 then fn.mkdir(swapdir, "", 0755) end
o.directory = swapdir

-- Table options
opt.backspace = {"indent", "eol", "start"}
opt.wildoptions = {"tagfile"}
opt.wildignore = {"node_modules/*", "**/node_modules/*", ".git/*", "**/.git/*", "**/dist/*", "dist/*"}
opt.fileencodings = {'utf-8'}
opt.encoding = 'UTF-8'
opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.virtualedit = {'block'}

opt.shortmess = opt.shortmess + 'Ic'

if (fn.has('langmap') ~= 0 and fn.exists('+langremap') ~= 0) then
    -- Prevent that the langmap option applies to characters that result from a
    -- mapping.  If set (default), this may break plugins (but it's backward
    -- compatible).
    o.langremap = false
end

-- plugins variables
env.NOTMUX = 1

g.netrw_banner = 0
g.loaded_matchit = 1
g.EditorConfig_exclude_patterns = {'fugitive://.*', 'scp://.*', 'NvimTree*'}
-- g.neovide_cursor_animation_length = 0

-- GUI Options

o.guifont = "SF Mono Powerline:h12"

if g.neovide ~= nil then require('environment').setup() end


o.clipboard = 'unnamedplus'

if (fn.has("wsl") == 1) then
    g.clipboard = {
      name = 'wsl-clip',
      copy = {
        -- + seems to be the register being used
        ['+'] = { 'wsl-clip', 'save' },
        ['*'] = { 'wsl-clip', 'save' },
      },
      paste = {
        -- + seems to be the register being used
        ['+'] = { 'wsl-clip', 'load' },
        ['*'] = { 'wsl-clip', 'load' },
      },
      cache_enabled = 1
    }

end

vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme gruvbox-material")
-- vim.cmd("colorscheme everforest")
-- vim.cmd("colorscheme solarized8")
-- vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme NeoSolarized")

-- require('lspinstall').setup()

require('lspconfig').pylsp.setup{}
require('lspconfig').gopls.setup{
    cmd_env = {GOFLAGS="-tags=integration"}
}

-- local lspconfig = require "lspconfig"
-- local util = require "lspconfig/util"
--
-- lspconfig.gopls.setup {
--   cmd = {"gopls", "serve"},
--   filetypes = {"go", "gomod"},
--   -- root_dir = util.root_pattern("go.work", "go.mod", ".git"),
--   settings = {
--     gopls = {
--       -- analyses = {
--       --   unusedparams = true,
--       -- },
--       -- staticcheck = true,
--       initializationOptions = {
--         buildFlags = {"-tags=wireinject"},
--       },
--     },
--   },
-- }

-- local lspconfig = require'lspconfig'
-- lspconfig.gopls.setup{
--   on_attach = require'completion'.on_attach;
--   settings = { gopls =  {
--       buildFlags =  {"-tags=integration"}
--     }
--   }
-- }


--
--
-- local lsp_installer = require("nvim-lsp-installer")
--
-- -- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- -- or if the server is already installed).
-- lsp_installer.on_server_ready(function(server)
--     local opts = {}
--
--     -- (optional) Customize the options passed to the server
--     -- if server.name == "tsserver" then
--     --     opts.root_dir = function() ... end
--     -- end
--
--     -- This setup() function will take the provided server configuration and decorate it with the necessary properties
--     -- before passing it onwards to lspconfig.
--     -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--     server:setup(opts)
-- end)

--

-- XXX - this isn't working
-- local cmp = require"cmp"
--
-- cmp.setup({
--    -- snippet = {
--    --    expand = function(args)
--    --       vim.fn["vsnip#anonymous"](args.body)
--    --    end,
--    -- },
--    mapping = {
--       ["<C-p>"] = cmp.mapping.select_prev_item(),
--       ["<C-n>"] = cmp.mapping.select_next_item(),
--       ["<C-d>"] = cmp.mapping.scroll_docs(-4),
--       ["<C-f>"] = cmp.mapping.scroll_docs(4),
--       ["<C-Space>"] = cmp.mapping.complete(),
--       ["<C-e>"] = cmp.mapping.close(),
--       ["<CR>"] = cmp.mapping.confirm({
--          behavior = cmp.ConfirmBehavior.Replace,
--          select = true,
--       }),
--       ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
--       ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
--    },
--    formatting = {
--       format = function(_, vim_item)
--          vim.cmd("packadd lspkind-nvim")
--          vim_item.kind = require("lspkind").presets.codicons[vim_item.kind]
--          .. "  "
--          .. vim_item.kind
--          return vim_item
--       end,
--    },
--    sources = {
--       { name = "nvim_lsp" },
--       { name = "vsnip" },
--       { name = "path" },
--    },
-- })
