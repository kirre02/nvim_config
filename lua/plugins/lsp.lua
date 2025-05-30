return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
        dependencies = {
            -- LSP installer plugins
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            -- Integrate blink w/ LSP
            "saghen/blink.cmp",
            -- Progress indicator for LSP
            { "j-hui/fidget.nvim" },
        },
        config = function()
            local map_lsp_keybinds = require("kirre.keymaps").map_lsp_keybinds

            -- Default LSP handlers with rounded borders
            local default_handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
            }

            local ts_ls_inlay_hints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            }

            -- on_attach: call your custom keymap binding function
            local on_attach = function(_client, buffer_number)
                map_lsp_keybinds(buffer_number)
            end

            -- List your LSP servers here.
            local servers = {
                bashls = {},
                cssls = {},
                eslint = {
                    autostart = false,
                    cmd = { "vscode-eslint-language-server", "--stdio", "--max-old-space-size=12288" },
                    settings = { format = false },
                },
                html = {},
                jsonls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    "${3rd}/luv/library",
                                    unpack(vim.api.nvim_get_runtime_file("", true)),
                                },
                            },
                            telemetry = { enabled = false },
                        },
                    },
                },
                marksman = {},
                nil_ls = {},
                pyright = {},
                sqlls = {},
                gopls = {},
                tailwindcss = {
                    filetypes = { "typescriptreact", "javascriptreact", "html", "svelte" },
                },
                ts_ls = {
                    on_attach = function(client, buffer_number)
                        require("twoslash-queries").attach(client, buffer_number)
                        return on_attach(client, buffer_number)
                    end,
                    settings = {
                        maxTsServerMemory = 12288,
                        typescript = { inlayHints = ts_ls_inlay_hints },
                        javascript = { inlayHints = ts_ls_inlay_hints },
                    },
                },
                yamlls = {},
                svelte = {},
                rust_analyzer = {
                    check = { command = "clippy", features = "all" },
                },
            }

            local formatters = {
                prettierd = {},
                stylua = {},
            }

            local manually_installed_servers = {"rust_analyzer" }
            local mason_tools_to_install = vim.tbl_keys(vim.tbl_deep_extend("force", {}, servers, formatters))
            local ensure_installed = vim.tbl_filter(function(name)
                return not vim.tbl_contains(manually_installed_servers, name)
            end, mason_tools_to_install)

            require("mason-tool-installer").setup({
                auto_update = true,
                run_on_start = true,
                start_delay = 3000,
                debounce_hours = 12,
                ensure_installed = ensure_installed,
            })

            -- Use blink.cmp to extend LSP capabilities.
            -- This replaces the cmp-nvim-lsp integration.
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Setup each LSP server. We merge in any server-specific capabilities by passing
            -- the existing config.capabilities to blink.cmp.get_lsp_capabilities.
            for name, config in pairs(servers) do
                require("lspconfig")[name].setup({
                    autostart = config.autostart,
                    cmd = config.cmd,
                    capabilities = capabilities,
                    filetypes = config.filetypes,
                    handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
                    on_attach = on_attach,
                    settings = config.settings,
                    root_dir = config.root_dir,
                })
            end

            -- Setup Mason for managing external LSP servers
            require("mason").setup({ ui = { border = "rounded" } })
            require("mason-lspconfig").setup()

            -- Configure borders for LspInfo UI and diagnostics
            require("lspconfig.ui.windows").default_options.border = "rounded"
            vim.diagnostic.config({ float = { border = "rounded" } })
        end,
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            notify_on_error = false,
            default_format_opts = {
                async = true,
                timeout_ms = 500,
                lsp_format = "fallback",
            },
            format_after_save = {
                async = true,
                timeout_ms = 500,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                javascript = { "biome" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
                svelte = { "prettierd", "prettier " },
                lua = { "stylua" },
            },
        },
    },
}

