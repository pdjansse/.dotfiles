return {
    "Mofiqul/vscode.nvim",
    name = "vscode",
    lazy = false,
    priority = 1000,

    -- test comments with link https://github.com/Mofiqul/vscode.nvim
    config = function()
        require('vscode').setup({
            transparent = true,
            italic_comments = false,
        })
        vim.cmd.colorscheme "vscode"
    end
}
