if vim.g.vscode then
    require("nconf.remap")
else
    vim.g.mapleader = " "
    require("nconf.lazy_init")
    require("nconf.set")
    require("nconf.remap")
    require("nconf.lsp")
end
