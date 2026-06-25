local colors = {
    bg = "#21252b",
    fg = "#abb2bf",
    fg_alt = "#828997",
    selection = "#323844",
    visual = "#3e4451",
    comment = "#828997",
    muted = "#5c6370",
    red = "#e06c75",
    orange = "#d19a66",
    green = "#98c379",
    yellow = "#e5c07b",
    blue = "#61afef",
    magenta = "#c678dd",
    cyan = "#56b6c2",
}

vim.opt.termguicolors = true

local function set_highlights()
    vim.g.colors_name = "atom-one-dark-zsh-transform"

    vim.g.terminal_color_0 = colors.bg
    vim.g.terminal_color_1 = colors.red
    vim.g.terminal_color_2 = colors.green
    vim.g.terminal_color_3 = colors.yellow
    vim.g.terminal_color_4 = colors.blue
    vim.g.terminal_color_5 = colors.magenta
    vim.g.terminal_color_6 = colors.cyan
    vim.g.terminal_color_7 = colors.fg
    vim.g.terminal_color_8 = colors.muted
    vim.g.terminal_color_9 = colors.red
    vim.g.terminal_color_10 = colors.green
    vim.g.terminal_color_11 = colors.yellow
    vim.g.terminal_color_12 = colors.blue
    vim.g.terminal_color_13 = colors.magenta
    vim.g.terminal_color_14 = colors.cyan
    vim.g.terminal_color_15 = colors.fg

    local groups = {
        Normal = { fg = colors.fg },
        NormalNC = { fg = colors.fg },
        EndOfBuffer = { fg = colors.muted },
        SignColumn = { fg = colors.fg_alt },
        FoldColumn = { fg = colors.fg_alt },
        LineNr = { fg = colors.fg_alt },
        CursorLine = {},
        CursorLineNr = { fg = colors.yellow, bold = true },
        ColorColumn = { bg = colors.visual },

        NormalFloat = { fg = colors.fg },
        FloatBorder = { fg = colors.blue },
        Pmenu = { fg = colors.fg },
        PmenuSel = { fg = colors.bg, bg = colors.blue },
        PmenuSbar = { bg = colors.visual },
        PmenuThumb = { bg = colors.fg_alt },

        StatusLine = { fg = colors.fg, bold = true },
        StatusLineNC = { fg = colors.fg_alt },
        TabLine = { fg = colors.fg_alt },
        TabLineSel = { fg = colors.fg, bold = true },
        TabLineFill = {},
        WinSeparator = { fg = colors.muted },

        Visual = { bg = colors.visual },
        Search = { fg = colors.bg, bg = colors.yellow },
        IncSearch = { fg = colors.bg, bg = colors.yellow },
        CurSearch = { fg = colors.bg, bg = colors.yellow },

        Comment = { fg = colors.comment, italic = true },
        Constant = { fg = colors.cyan },
        String = { fg = colors.green },
        Character = { fg = colors.green },
        Number = { fg = colors.orange },
        Boolean = { fg = colors.orange },
        Float = { fg = colors.orange },
        Identifier = { fg = colors.red },
        Function = { fg = colors.blue },
        Statement = { fg = colors.magenta },
        Conditional = { fg = colors.magenta },
        Repeat = { fg = colors.magenta },
        Label = { fg = colors.magenta },
        Operator = { fg = colors.cyan },
        Keyword = { fg = colors.magenta },
        Exception = { fg = colors.magenta },
        PreProc = { fg = colors.yellow },
        Include = { fg = colors.blue },
        Define = { fg = colors.magenta },
        Macro = { fg = colors.magenta },
        PreCondit = { fg = colors.yellow },
        Type = { fg = colors.yellow },
        StorageClass = { fg = colors.yellow },
        Structure = { fg = colors.yellow },
        Typedef = { fg = colors.yellow },
        Special = { fg = colors.cyan },
        SpecialChar = { fg = colors.cyan },
        Tag = { fg = colors.red },
        Delimiter = { fg = colors.fg },
        Underlined = { fg = colors.blue, underline = true },
        Todo = { fg = colors.yellow, bold = true },
        Error = { fg = colors.red },

        DiagnosticError = { fg = colors.red },
        DiagnosticWarn = { fg = colors.yellow },
        DiagnosticInfo = { fg = colors.blue },
        DiagnosticHint = { fg = colors.cyan },
        DiagnosticOk = { fg = colors.green },
        DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
        DiagnosticUnderlineWarn = { sp = colors.yellow, undercurl = true },
        DiagnosticUnderlineInfo = { sp = colors.blue, undercurl = true },
        DiagnosticUnderlineHint = { sp = colors.cyan, undercurl = true },

        Directory = { fg = colors.blue },
        NonText = { fg = colors.muted },
        SpecialKey = { fg = colors.muted },
        ErrorMsg = { fg = colors.red },
        WarningMsg = { fg = colors.yellow },
        ModeMsg = { fg = colors.green },
        MoreMsg = { fg = colors.green },
        Question = { fg = colors.blue },

        ["@comment"] = { fg = colors.comment, italic = true },
        ["@constant"] = { fg = colors.cyan },
        ["@constant.builtin"] = { fg = colors.orange },
        ["@string"] = { fg = colors.green },
        ["@string.escape"] = { fg = colors.cyan },
        ["@number"] = { fg = colors.orange },
        ["@boolean"] = { fg = colors.orange },
        ["@variable"] = { fg = colors.fg },
        ["@variable.builtin"] = { fg = colors.red },
        ["@variable.parameter"] = { fg = colors.orange },
        ["@property"] = { fg = colors.red },
        ["@function"] = { fg = colors.blue },
        ["@function.call"] = { fg = colors.blue },
        ["@function.method"] = { fg = colors.blue },
        ["@constructor"] = { fg = colors.yellow },
        ["@keyword"] = { fg = colors.magenta },
        ["@keyword.function"] = { fg = colors.magenta },
        ["@keyword.return"] = { fg = colors.magenta },
        ["@conditional"] = { fg = colors.magenta },
        ["@repeat"] = { fg = colors.magenta },
        ["@operator"] = { fg = colors.cyan },
        ["@type"] = { fg = colors.yellow },
        ["@type.builtin"] = { fg = colors.yellow },
        ["@module"] = { fg = colors.yellow },
        ["@punctuation.delimiter"] = { fg = colors.fg },
        ["@punctuation.bracket"] = { fg = colors.fg },
    }

    for group, opts in pairs(groups) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Keep zsh transform colors matched to the terminal palette",
    group = vim.api.nvim_create_augroup("ZshTransformColors", {
        clear = true,
    }),
    callback = set_highlights,
})

set_highlights()
