return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            local gitsigns = require 'gitsigns'

            gitsigns.setup {
                signs = {
                    add          = { text = '┃' },
                    change       = { text = '┃' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
            }
        end
    }
}
