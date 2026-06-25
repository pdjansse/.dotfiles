if vim.env.NVIM_ZSH_TRANSFORM == "1" then
    vim.g.mapleader = " "
    require("nconf.set")
    require("nconf.remap")
    require("nconf.zsh_transform")
    return
end

if vim.g.vscode then
    require("nconf.remap")
else
    vim.g.mapleader = " "
    require("nconf.lazy_init")
    require("nconf.set")
    require("nconf.remap")
    require("nconf.lsp")
end
