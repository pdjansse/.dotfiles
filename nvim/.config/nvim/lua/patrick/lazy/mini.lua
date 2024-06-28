return {
    "echasnovski/mini.nvim",

    tag = "v0.13.0",

    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        -- local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        -- statusline.setup { use_icons = vim.g.have_nerd_font }
    end,
}
