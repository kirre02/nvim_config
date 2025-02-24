return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        event = "VeryLazy",
        config = function()
            local function truncate_branch_name(branch)
                if not branch or branch == "" then
                    return ""
                end

                -- Match the branch name to the specified format
                local _, _, ticket_number = string.find(branch, "skkirre02/sko%-(%d+)%-")

                -- If the branch name matches the format, display sko-{ticket_number}, otherwise display the full branch name
                if ticket_number then
                    return "sko-" .. ticket_number
                else
                    return branch
                end
            end


            local lualine = require("lualine")
            local noice = require("noice")

            lualine.setup({
                options = {
                    theme = "tokyonight",
                    icons_enabled = true,
                    globalstatus = true,
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    sections = {
                        lualine_b = {
                            { "branch", icon = "¿", fmt = truncate_branch_name },
                            "diff",
                            "diagnostics",
                        },
                        lualine_c = {
                            { "filename", path = 1 },
                        },
                        lualine_x = {
                            noice.api.status.message.get_hl,
                            cond = noice.api.status.message.has,
                        },
                        {
                            noice.api.status.command.get,
                            cond = noice.api.status.command.has,
                            color = { fg = "#EED49F" },
                        },
                        {
                            noice.api.status.mode.get,
                            cond = noice.api.status.mode.has,
                            color = { fg = "#EED49F" },
                        },
                        {
                            noice.api.status.search.get,
                            cond = noice.api.status.search.has,
                            color = { fg = "#EED49F" },
                        },
                    },
                },
            })
        end,
    },
}
