return {
    "Mofiqul/vscode.nvim",
    name = "vscode",
    lazy = false,
    priority = 1000,

    -- test comments with link https://github.com/Mofiqul/vscode.nvim
    config = function()
        local c = require("vscode.colors").get_colors()
        require("vscode").setup({
            transparent = true,
            italic_comments = false,
            group_overrides = {
                GitSignsChange = { fg = c.vscBlue, bg = "NONE" },
                GitSignsChangeLn = { fg = c.vscBack, bg = c.vscBlue },
            },
        })
        vim.cmd.colorscheme("vscode")
    end,
}
