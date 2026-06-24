---@brief
---
--- https://github.com/DanielGavin/ols
---
--- `Odin Language Server`.

local function escape_wildcards(path)
    return path:gsub("([%[%]%?%*])", "\\%1")
end

local function strip_archive_subpath(path)
    path = vim.fn.substitute(path, "zipfile://\\(.\\{-}\\)::[^\\\\].*$", "\\1", "")
    path = vim.fn.substitute(path, "tarfile:\\(.\\{-}\\)::.*$", "\\1", "")
    return path
end

local function search_ancestors(startpath, func)
    if func(startpath) then
        return startpath
    end
    local guard = 100
    for path in vim.fs.parents(startpath) do
        guard = guard - 1
        if guard == 0 then
            return
        end
        if func(path) then
            return path
        end
    end
end

local function root_pattern(...)
    -- Simple flatten replacing M.tbl_flatten to avoid Neovim deprecation warnings
    local patterns = {}
    for _, p in ipairs({ ... }) do
        if type(p) == "table" then
            for _, v in ipairs(p) do
                table.insert(patterns, v)
            end
        else
            table.insert(patterns, p)
        end
    end

    return function(startpath)
        startpath = strip_archive_subpath(startpath)
        for _, pattern in ipairs(patterns) do
            local match = search_ancestors(startpath, function(path)
                for _, p in
                    ipairs(
                        vim.fn.glob(
                            table.concat({ escape_wildcards(path), pattern }, "/"),
                            true,
                            true
                        )
                    )
                do
                    if vim.uv.fs_stat(p) then
                        return path
                    end
                end
            end)

            if match ~= nil then
                local real = vim.uv.fs_realpath(match)
                return real or match -- fallback to original if realpath fails
            end
        end
    end
end

---@type vim.lsp.Config
return {
    cmd = { "ols" },
    filetypes = { "odin" },
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        on_dir(root_pattern("ols.json", ".git", "*.odin")(fname))
    end,
}
