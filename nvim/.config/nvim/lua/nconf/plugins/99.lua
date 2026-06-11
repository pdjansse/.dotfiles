return {
    "ThePrimeagen/99",
    -- dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local _99 = require("99")

        local PiProvider = setmetatable({}, { __index = _99.Providers.BaseProvider })

        function PiProvider._build_command(_, query, context)
            return {
                "pi",
                "--model",
                context.model,
                "--print",
                query,
            }
        end

        function PiProvider._get_provider_name()
            return "PiProvider"
        end

        function PiProvider._get_default_model()
            -- Helper function to read and parse the Pi settings JSON
            local function read_model_from_json(path)
                local f = io.open(path, "r")
                if not f then
                    return nil
                end
                local content = f:read("*a")
                f:close()

                -- Use Neovim's native JSON decoder
                local ok, json = pcall(vim.json.decode, content)
                if ok and type(json) == "table" and type(json.model) == "string" then
                    return json.model
                end
                return nil
            end

            local cwd_model =
                read_model_from_json(vim.fn.getcwd() .. "/.pi/settings.json")
            if cwd_model then
                return cwd_model
            end

            local home = os.getenv("HOME") or os.getenv("USERPROFILE")
            if home then
                local global_model =
                    read_model_from_json(home .. "/.pi/agent/settings.json")
                if global_model then
                    return global_model
                end
            end

            return "model"
        end

        function PiProvider.fetch_models(callback)
            vim.system({ "pi", "--list-models" }, { text = true }, function(obj)
                vim.schedule(function()
                    if obj.code ~= 0 then
                        callback(nil, "Failed to fetch models from pi")
                        return
                    end
                    local models = {}
                    for _, line in
                        ipairs(vim.split(obj.stdout, "\n", { trimempty = true }))
                    do
                        local id = line:match("^(%S+)")
                        if
                            id
                            and not id:match("^%-+$")
                            and id:lower() ~= "model"
                            and id:lower() ~= "provider"
                        then
                            table.insert(models, id)
                        end
                    end
                    callback(models, nil)
                end)
            end)
        end

        local cwd = vim.uv.cwd()
        local basename = vim.fs.basename(cwd)

        _99.setup({
            provider = PiProvider,
            logger = {
                level = _99.DEBUG,
                path = "/tmp/" .. basename .. ".99.debug",
                print_on_error = true,
            },
            tmp_dir = "./tmp",

            completion = {
                custom_rules = {
                    "scratch/custom_rules/",
                },
                files = {
                    enabled = true,
                    max_file_size = 102400,
                    max_files = 5000,
                    exclude = { ".env", ".env.*", "node_modules", ".git", "tmp" },
                },
                source = "native",
            },

            md_files = {
                "AGENT.md",
            },
        })

        -- Keymaps
        vim.keymap.set("v", "<leader>9v", function()
            _99.visual()
        end)

        vim.keymap.set("n", "<leader>9x", function()
            _99.stop_all_requests()
        end)

        vim.keymap.set("n", "<leader>9s", function()
            _99.search()
        end)
    end,
}
