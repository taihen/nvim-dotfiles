local api = vim.api

api.nvim_set_keymap(
  "n",
  "<leader>fh",
  "<cmd>lua require('telescope').extensions.lazygit.lazygit()<CR>",
  { noremap = true }
)
