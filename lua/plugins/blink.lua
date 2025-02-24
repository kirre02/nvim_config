return {
    "saghen/blink.cmp",
    opts = {
        sources = {
            default = { 'lsp', 'path', 'snippets' },
            providers = {
                lsp = {
                    name = "lsp",
                    enabled = true,
                    module = "blink.cmp.sources.lsp",
                    min_keyword_length = 2,
                    -- When linking markdown notes, I would get snippets and text in the
                    -- suggestions, I want those to show only if there are no LSP
                    -- suggestions
                    --
                    -- Enabled fallbacks as this seems to be working now
                    -- Disabling fallbacks as my snippets wouldn't show up when editing
                    -- lua files
                    -- fallbacks = { "snippets", "buffer" },
                    score_offset = 90, -- the higher the number, the higher the priority
                },
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 25,
                    -- When typing a path, I would get snippets and text in the
                    -- suggestions, I want those to show only if there are no path
                    -- suggestions
                    fallbacks = { "snippets", "buffer" },
                    min_keyword_length = 2,
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true,
                        get_cwd = function(context)
                            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
                        end,
                        show_hidden_files_by_default = true,
                    },
                },
            },
        },
        keymap = {
            preset = "default",
            ["<Enter>"] = { "accept", "fallback" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        },
    },
}
