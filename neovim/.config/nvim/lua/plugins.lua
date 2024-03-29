local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    Packer_bootstrap = fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    execute 'packadd packer.nvim'
end

vim.g.did_load_filetypes = 1

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Performance
    use "nathom/filetype.nvim"

    -- File navigation
    use {
        'nvim-telescope/telescope.nvim',
        opt = true,
        cmd = "Telescope",
        module = 'telescope',
        requires = {
            {'nvim-lua/plenary.nvim'}, {
                'nvim-telescope/telescope-fzf-native.nvim',
                opt = true,
                event = "UIEnter",
                run = 'make'
            }, {
                'benfowler/telescope-luasnip.nvim',
                opt = true,
                module = 'telescope._extensions.luasnip'
            }
        },
        -- config = function() require'others'.telescope() end
        config = function()
            require("telescope").setup {
              extensions = {
                fzf = {
                  fuzzy = true,                    -- false will only do exact matching
                  override_generic_sorter = true,  -- override the generic sorter
                  override_file_sorter = true,     -- override the file sorter
                  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                                   -- the default case_mode is "smart_case"
                }
              }
            }
        end
    }
    use {
        'BurntSushi/ripgrep'
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons',
            -- opt = true
        },
        -- event = "UIEnter",
        config = function()
            require'nvim-tree'.setup {
                update_cwd = true
            }
        end
    }

    -- tbaggery
    use {
        'tpope/vim-fugitive',
        opt = true,
        cmd = {"Git", "Gread", "Gwrite", "Gcd", "Glcd" }
    }
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    }
    use {
        'rebelot/kanagawa.nvim',
    }
    use {
        'sainnhe/gruvbox-material'
    }
    use {
        'sainnhe/everforest'
    }
    use {
        'lifepillar/vim-solarized8'
    }
    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        opt = true,
        -- event = "UIEnter",
        event = "VimEnter",
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                -- one of "all", "maintained", or a list of languages
                -- ensure_installed = "maintained",
                ensure_installed = { "c", "lua", "rust" , "go", "python", "typescript", "json", "yaml"},
                sync_install = false,
                highlight = {
                    enable = true -- false will disable the whole extension
                    -- disable = { "c", "rust" },  -- list of language that will be disabled
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<leader>+",
                        node_incremental = "<leader>=",
                        node_decremental = "<leader>-",
                        scope_incremental = "<leader>}",
                        scope_decremental = "<leader>{"
                    }
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ap"] = "@parameter.outer",
                            ["ip"] = "@parameter.inner"
                        }
                    }
                },
                matchup = {
                    enable = true
                }
            }

        end
    }
    use {
        'windwp/nvim-ts-autotag',
        after = "nvim-treesitter",
        config = function() require('nvim-ts-autotag').setup() end
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = "nvim-treesitter"
    }

    -- Appeareance
    use {
        'norcalli/nvim-colorizer.lua',
        opt = true,
        event = "InsertEnter",
        config = function() require('colorizer').setup() end
    }
    use { -- It is more complicated making a custom tabline than a statusline, this one's lean
        'alvarosevilla95/luatab.nvim',
        opt = true,
        event = "UIEnter",
        requires = {
            {
                'kyazdani42/nvim-web-devicons',
                opt = true
            }
        },
        config = function() require'luatab'.setup({}) end
    }
    use {
        "lukas-reineke/indent-blankline.nvim",
        opt = true,
        event = "InsertEnter",
        config = function()
            require("indent_blankline").setup {
                char = '│',
                filetype_exclude = {'help', 'packer'},
                buftype_exclude = {'terminal', 'nofile'},
                char_highlight = 'LineNr',
                show_trailing_blankline_indent = false,
                -- show_first_indent_level = false,
                use_treesitter = true
            }
        end
    }
    use {
        'rcarriga/nvim-notify',
        opt = true,
        module = 'notify'
    }

    -- Misc
    use {
        'editorconfig/editorconfig-vim',
        opt = true,
        cond = function()
            return vim.fn.filereadable('.editorconfig') == 1
        end
    }
    use {
        'mattn/emmet-vim',
        ft = {
            'html', 'css', 'javascript', 'javascriptreact', 'vue', 'typescript',
            'typescriptreact'
        }
    }
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({
                check_ts = true
            })
        end
    }
    use {
        'andymass/vim-matchup',
        opt = true,
        event = "BufRead"
    }

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        -- event = 'VimEnter',
        -- config = function() require'lsp'.setup() end
    }
    use {
        'williamboman/nvim-lsp-installer',
        opt = true,
        module = 'nvim-lsp-installer',
        run = function()
            local lsp_installer = require 'nvim-lsp-installer'
            -- Ensure installed
            local servers = {
                -- "sumneko_lua", "tsserver", "tailwindcss", "pyright", "clangd", "cssls", "pylsp"
                "sumneko_lua", "pylsp", "gopls", "pyright"
            }

            for _, name in pairs(servers) do
                local server_is_found, server = lsp_installer.get_server(name)
                if (server_is_found and not server:is_installed()) then
                    print("Installing " .. name)
                    server:install()
                end
            end
        end
    }

    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        event = "UIEnter",
        opt = true,
        requires = {
            {
                'hrsh7th/cmp-nvim-lsp',
                module = "cmp_nvim_lsp",
                opt = true
            }, {
                'hrsh7th/cmp-buffer',
                opt = true
            }, {
                'hrsh7th/cmp-path',
                opt = true
            }, {
                'hrsh7th/cmp-nvim-lua',
                opt = true
            }, {
                'saadparwaiz1/cmp_luasnip',
                opt = true
            }
        },
        config = function() require'completion'.setup() end
    }
    use {
        'L3MON4D3/LuaSnip',
        after = "nvim-cmp",
        requires = {{"rafamadriz/friendly-snippets"}},
        config = function() require'completion'.luasnip() end
    }

    -- require("luasnip.loaders.from_snipmate").load()

    -- VCS
    use {
        'lewis6991/gitsigns.nvim',
        opt = true,
        event = "UIEnter",
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require'others'.gitsigns() end
    }

    -- use { 'scrooloose/nerdtree' }
    -- use { 'Xuyuanp/nerdtree-git-plugin' }

    if Packer_bootstrap then require('packer').sync() end
end)


