return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        require("fidget").setup({}) -- Enable Fancy Messages

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local opts = {buffer = event.buf}

                -- these will be buffer-local keybindings
                -- because they only work if you have an active language server

                vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            end
        })

        local cmp = require('cmp')
        local cmp_lsp = require('cmp_nvim_lsp')
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        local default_setup = function(server)
            require('lspconfig')[server].setup({
                capabilities = capabilities,
            })
        end
        local lua_ls = function()
            require('lsponfig').lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {version = 'LuaJIT'},
                        diagonostics = { globals = {'vim'} },
                        workspace = { library = { vim.env.VIMRUNTIME } }
                    }
                }
            })
        end
        require("mason").setup({})  -- Lsp Installer
        require("mason-lspconfig").setup({ -- Link Mason LSPs with lspconfig
            ensure_installed = {
                "lua_ls",
                "ruff_lsp",
                "pyright",
            },
            handlers = {
                default_setup,
                lua_ls,
            },
        })

        -- Setup Compilations
        local cmp = require('cmp')

        cmp.setup({
             sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
                { name = 'path' },
            }, {
                { name = 'buffer' },
            }),


            mapping = cmp.mapping.preset.insert({
                -- Enter key confirms completion item
                ['<CR>'] = cmp.mapping.confirm({select = false}),

                -- Ctrl + space triggers completion menu
                ['<C-Space>'] = cmp.mapping.complete(),
            }),

            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            }
        })
    end
}
