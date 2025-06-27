return {
    "luukvbaal/nnn.nvim",
    config = function()
        require("nnn").setup({
            explorer = {
                cmd = "nnn -H -o -U", -- command override (-F1 flag is implied, -a flag is invalid!)
                width = 32, -- width of the vertical split
            },
            picker = {
                cmd = "nnn -H -o -U",
                style = { border = "rounded" },
                session = "shared",
            },
            replace_netrw = "picker",
        })

        vim.keymap.set("n", "<leader>e", ":NnnExplorer<CR>")
        vim.keymap.set("n", "<leader>p", ":NnnPicker<CR>")
    end,
}
