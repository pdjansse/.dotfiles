if vim.g.vscode then
    -- pass
else
    vim.g.mapleader = " "
    require("nconf.lazy_init")
    require("nconf.set")
    require("nconf.remap")
    require("nconf.lsp")
end
