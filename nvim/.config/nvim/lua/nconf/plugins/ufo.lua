return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    opts = function()
        local handler = function(virtText, lnum, endLnum, width, truncate)
            local result = {}
            local full_text = ""

            -- Reconstruct the full text to safely find the LAST bracket
            for _, chunk in ipairs(virtText) do
                full_text = full_text .. chunk[1]
            end

            local target_bracket = nil
            local target_idx = -1
            local pairs = { ["{"] = "}", ["["] = "]", ["("] = ")" }

            for i = #full_text, 1, -1 do
                local c = full_text:sub(i, i)
                if pairs[c] then
                    target_bracket = c
                    target_idx = i
                    break
                end
            end

            local current_len = 0
            local bracket_hl = "Comment"

            for _, chunk in ipairs(virtText) do
                local text = chunk[1]
                local hl = chunk[2] -- MUST stay a string, or UFO breaks the colors
                local chunk_len = #text

                if target_bracket and (current_len + chunk_len >= target_idx) then
                    local bracket_pos_in_chunk = target_idx - current_len
                    bracket_hl = hl

                    -- Grab text before the bracket
                    local before_bracket = text:sub(1, bracket_pos_in_chunk - 1)
                    if before_bracket ~= "" then
                        table.insert(result, { before_bracket, hl })
                    end

                    -- THE FIX: Walk backwards through our collected chunks and violently
                    -- strip trailing whitespace so we never get `proc "system"   (...)`
                    while #result > 0 do
                        local last = result[#result]
                        local trimmed = last[1]:gsub("%s+$", "")
                        if trimmed == "" then
                            table.remove(result) -- Chunk was just spaces, kill it
                        else
                            last[1] = trimmed
                            break
                        end
                    end
                    break -- Drop everything after the bracket
                else
                    table.insert(result, { text, hl })
                    current_len = current_len + chunk_len
                end
            end

            -- Append the correct suffix (e.g., " {...}", " (...)", " [...]")
            if target_bracket then
                local closing = pairs[target_bracket]
                table.insert(
                    result,
                    { " " .. target_bracket .. "..." .. closing, bracket_hl }
                )
            else
                -- Fallback for braceless languages like Python
                while #result > 0 do
                    local last = result[#result]
                    local trimmed = last[1]:gsub("%s+$", "")
                    if trimmed == "" then
                        table.remove(result)
                    else
                        last[1] = trimmed
                        break
                    end
                end
                table.insert(result, { " ...", "Comment" })
            end

            return result
        end

        return {
            fold_virt_text_handler = handler,
            provider_selector = function(bufnr, filetype, buftype)
                return { "treesitter", "indent" }
            end,
        }
    end,
    init = function()
        vim.opt.foldlevel = 99
        vim.opt.foldlevelstart = 99
        vim.opt.foldenable = true
        vim.opt.fillchars:append({ fold = " " })

        -- THE FIX FOR ITALICS: Safely tell Neovim's core highlighting engine
        -- to make folded backgrounds and text italic, instead of fighting UFO.
        vim.api.nvim_set_hl(0, "Folded", { italic = true, default = false })

        -- Ensure the italics persist even if you change colorschemes later
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                vim.api.nvim_set_hl(0, "Folded", { italic = true, default = false })
            end,
        })
    end,
}
