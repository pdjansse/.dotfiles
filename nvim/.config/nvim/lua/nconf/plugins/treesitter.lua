return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    config = function()
        require("nvim-treesitter.config").setup({
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "c",
                "python",
                "bash",
                "go",
                "query",
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
                disable = { "python", "c" },
            },
        })
    end,
}
