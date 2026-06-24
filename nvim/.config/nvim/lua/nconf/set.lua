vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.list = true
vim.opt.listchars = "tab:  ,trail:.,extends:>,precedes:<"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes:1"
vim.opt.scrolloff = 8
vim.opt.showcmd = true

local undodir_path = os.getenv("HOME") .. "/.nvim/undodir"
if vim.fn.isdirectory(undodir_path) == 0 then
    vim.fn.mkdir(undodir_path, "p")
end
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = undodir_path
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.viewoptions = { "cursor", "folds" }

-- Save the fold view when leaving a buffer or closing a window
local fold_group = vim.api.nvim_create_augroup("RememberFolds", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
    group = fold_group,
    pattern = "*",
    callback = function()
        -- Only save views for actual, editable files on disk
        if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! mkview")
        end
    end,
})

-- Load the fold view when entering a buffer
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = fold_group,
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! loadview")
        end
    end,
})

-- No automatic comment insertion
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- Sync yank buffers between nvim instances
local sync_shada_grp =
    vim.api.nvim_create_augroup("SyncShadaRegisters", { clear = true })

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = sync_shada_grp,
    desc = "Write yanked registers to ShaDa file immediately",
    callback = function()
        -- Only sync actual yanks (ignore deletions/changes)
        if vim.v.event.operator == "y" then
            vim.cmd("wshada")
        end
    end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    group = sync_shada_grp,
    desc = "Read fresh registers from ShaDa when switching back to Neovim",
    callback = function()
        vim.cmd("rshada")
    end,
})
