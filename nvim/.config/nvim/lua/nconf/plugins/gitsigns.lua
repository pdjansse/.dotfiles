return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
            end

            -- Navigation
            map("n", "]h", gs.next_hunk, "Next Hunk")
            map("n", "[h", gs.prev_hunk, "Prev Hunk")

            -- Actions
            map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
            map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
            map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
            map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
            map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
            map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
            map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle Blame")
            map("n", "<leader>td", gs.toggle_deleted, "Toggle Deleted")

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
        end,
    },
}
