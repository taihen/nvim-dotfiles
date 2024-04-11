vim.g.better_whitespace_enabled = "1"
vim.g.strip_whitespace_on_save = "1"
vim.g.strip_whitespace_confirm = "0"
vim.g.strip_whitelines_at_eof = "1"
vim.g.strip_only_modified_lines = "0"
-- -- that does not seems to work anymore
-- vim.g.better_whitespace_guicolor = "#af3a03"
-- vim.g.better_whitespace_ctermcolor = "#af3a03"
-- -- i do not use ss as it does strip on save
-- local opts = { noremap = true, silent = true }
-- vim.api.nvim_set_keymap("n", "<leader>ss", ":StripWhitespace<CR>", opts)
