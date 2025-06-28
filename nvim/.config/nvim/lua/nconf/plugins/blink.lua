return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets", "xzbdmw/colorful-menu.nvim" },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    config = function(_, opts)
        require("blink.cmp").setup(opts)

        local function apply_ayu_highlights()
            if vim.g.colors_name ~= "ayu" then
                return
            end

            local ok, colors = pcall(require, "ayu.colors")
            if not ok then
                return
            end

            vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = colors.selection_inactive })
            vim.api.nvim_set_hl(
                0,
                "BlinkCmpMenuSelection",
                { bg = colors.selection_bg }
            )
            vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = colors.panel_bg })
            vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.panel_border })
            vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { fg = colors.line })
            vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = colors.panel_bg })
            vim.api.nvim_set_hl(
                0,
                "BlinkCmpSignatureHelpBorder",
                { fg = colors.panel_border }
            )
            vim.api.nvim_set_hl(
                0,
                "BlinkCmpSignatureHelpBorder",
                { fg = colors.panel_border }
            )
            vim.api.nvim_set_hl(
                0,
                "BlinkCmpSignatureHelpActiveParameter",
                { fg = colors.BlinkCmpSignatureHelpBorder }
            )
        end

        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "ayu",
            callback = apply_ayu_highlights,
            desc = "Apply ayu colors to blink.cmp docs",
        })

        apply_ayu_highlights()
    end,

    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = "enter" },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            menu = {
                draw = {
                    columns = {
                        { "label", gap = 1 },
                        { "kind_icon" },
                        { "source_name" },
                    },
                    components = {
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(
                                    ctx
                                )
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(
                                    ctx
                                )
                            end,
                        },
                    },
                },
            },
            ghost_text = {
                enabled = false,
            },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        -- removed "snippets"
        sources = {
            default = { "lsp", "path", "buffer" },
        },

        signature = { enabled = true },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
