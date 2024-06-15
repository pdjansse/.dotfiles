-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true


-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'


-- Makes Tabs behave like Spaces
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true


-- Disable wraping
vim.opt.wrap = false


-- Search Options
vim.opt.hlsearch = false
vim.opt.incsearch = true


-- Fancy Colors
vim.termguicolors = true


-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 8


-- Decrease update time
vim.opt.updatetime = 250


-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false


-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false


-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'


-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }


-- Show which line your cursor is on
-- vim.opt.cursorline = true
