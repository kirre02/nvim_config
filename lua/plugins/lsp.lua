return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            "nvimtools/none-ls.nvim",
            "folke/neodev.nvim",
            { "j-hui/fidget.nvim", tag = "legacy" },
        },
        config = function()
            local null_ls = require("null-ls")

            require("neodev").setup()
            require("mason").setup({ ui = { border = "rounded" } })
            require("mason-lspconfig").setup({ automatic_installation = { exclude = { "ocamllsp", "gleam" } } })

            -- Enable `blink.cmp` capabilities for LSP
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            local servers = {
                bashls = {},
                cssls = {},
                html = {},
                jsonls = {},
                lua_ls = { settings = { Lua = { workspace = { checkThirdParty = false }, telemetry = { enabled = false } } } },
                prismals = {},
                pyright = {},
                solidity = {},
                ts_ls = {},
                yamlls = {},
            }

            local function lsp_keymaps(bufnr)
                local opts = { noremap = true, silent = true }
                local keymap = vim.api.nvim_buf_set_keymap
                keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
                keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
                keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
                keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
                keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
                keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
                keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
                keymap(bufnr, "n", "<leader>lI", "<cmd>Mason<cr>", opts)
                keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
                keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
            end

            local on_attach = function(client, bufnr)
                lsp_keymaps(bufnr)

                -- Format on save if the LSP supports it
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end

            for name, config in pairs(servers) do
                require("lspconfig")[name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = config.settings,
                })
            end

            -- Setup `null-ls`
            null_ls.setup({
                border = "rounded",
                sources = {
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.formatting.stylua,
                    --  null_ls.builtins.diagnostics.eslint_d.with({
                    --     condition = function(utils)
                    --       return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json" })
                    --  end,
                    -- }),
                },
            })

            vim.diagnostic.config({ float = { border = "rounded" } })
        end,
    },
}
