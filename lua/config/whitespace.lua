-- Highlight trailing whitespace
vim.api.nvim_set_hl(0, "TrailingWhitespace", { ctermbg = 88 })

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
    callback = function()
        vim.schedule(function()
            if vim.w.trailing_ws_match then
                return
            end
            if vim.bo.buftype == "" then
                vim.fn.matchadd("TrailingWhitespace", [[\s\+$]], 0)
                vim.w.trailing_ws_match = true
            end
        end)
    end,
})
