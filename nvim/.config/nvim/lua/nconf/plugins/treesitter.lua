vim.filetype.add({
    extension = {
        vala = "vala",
        vapi = "vala",
    },
})

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",

    config = function()
        require("nvim-treesitter").install({
            "lua",
            "vim",
            "vimdoc",
            "c",
            "cpp",
            "json",
            "markdown",
            "toml",
            "yaml",
            "python",
            "bash",
            "zsh",
            "go",
            "query",
            "vala",
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "lua", "vim", "vimdoc", "bash", "go", "query", "vala" },
            callback = function(args)
                vim.bo[args.buf].indentexpr =
                    "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
