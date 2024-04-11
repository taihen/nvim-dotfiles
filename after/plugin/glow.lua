require("glow").setup({
  pager = false,
  style = "dark",
  border = "shadow",
  width = 120,
  width_ratio = 0.9,
  height_ratio = 0.9,
})

vim.api.nvim_set_keymap(
  "n",
  "<leader>m",
  ":Glow<CR>",
  { noremap = true, silent = true }
)
