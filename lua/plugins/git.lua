-- Git integration with gitsigns
return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = {
                follow_files = true,
            },
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            sign_priority = 6,
            update_debounce = 100,
            max_file_length = 40000,
            preview_config = {
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Next [C]hange (git hunk)" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Previous [C]hange (git hunk)" })

                -- Actions
                map("n", "<leader>hs", gs.stage_hunk, { desc = "[H]unk [S]tage" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "[H]unk [R]eset" })
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "[H]unk [S]tage (visual)" })
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "[H]unk [R]eset (visual)" })
                map("n", "<leader>hS", gs.stage_buffer, { desc = "[H]unk [S]tage buffer" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "[H]unk [U]ndo stage" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "[H]unk [R]eset buffer" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "[H]unk [P]review" })
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end, { desc = "[H]unk [B]lame line" })
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "[T]oggle [B]lame line" })
                map("n", "<leader>hd", gs.diffthis, { desc = "[H]unk [D]iff this" })
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, { desc = "[H]unk [D]iff ~" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "[T]oggle [D]eleted" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "[I]nside [H]unk" })
            end,
        },
    },
}
