vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
vim.keymap.set(
    "n",
    "<leader>r",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace all in current buffer" }
)

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlights text when yanking",
    group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.api.nvim_create_user_command("W", "write", {})

-- lsp actions
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover" })
vim.keymap.set(
    "n",
    "<leader>.",
    vim.lsp.buf.code_action,
    { noremap = true, silent = true, desc = "Code Action" }
)
vim.keymap.set(
    "n",
    "gd",
    "<cmd>lua vim.lsp.buf.definition()<cr>",
    { desc = "Go to definition" }
)
vim.keymap.set(
    "n",
    "gD",
    "<cmd>lua vim.lsp.buf.declaration()<cr>",
    { desc = "Go to declaration" }
)
vim.keymap.set(
    "n",
    "gi",
    "<cmd>lua vim.lsp.buf.implementation()<cr>",
    { desc = "Go to implementation" }
)
vim.keymap.set(
    "n",
    "go",
    "<cmd>lua vim.lsp.buf.type_definition()<cr>",
    { desc = "Go to type definition" }
)
vim.keymap.set(
    "n",
    "gr",
    "<cmd>lua vim.lsp.buf.references()<cr>",
    { desc = "Go to references" }
)
vim.keymap.set(
    "n",
    "gs",
    "<cmd>lua vim.lsp.buf.signature_help()<cr>",
    { desc = "Show signature help" }
)
vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
