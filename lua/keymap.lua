-- shorthanded notations
local keymap = vim.keymap.set
local api = vim.api

-- use a particular leader, which is not set other way
keymap("n", "<space>", "", {})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- defaults
options = { noremap = true, silent = true }

-- Write without exit
keymap("n", "<leader>wf", ":write<CR>", { desc = "NVIM: [W]rite [F]ile" })

-- replace without creating a new register in visual mode
keymap("n", "<leader>p", '"_dP', options)

-- delete without creating a new register in normal mode
keymap("n", "x", '"_x', options)

-- remove highligthing with esc
keymap("n", "<leader><esc>", ":nohlsearch<cr>", options)

-- simplify switching between buffers with , and .
keymap("n", "<leader>,", ":bprev<cr>", options)
keymap("n", "<leader>.", ":bnext<cr>", options)

-- quick delete buffer
keymap("n", "<leader>/", ":bdelete<CR>", options)

-- remove unused ex keybind
keymap("", "Q", "<Nop>", options)

-- resize split vertical buffers
keymap("n", "<leader>-", "<cmd>vertical resize -5", options)
keymap("n", "<leader>+", "<cmd>vertical resize +5", options)

-- moving lines in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv'", options)
keymap("v", "K", ":m '<-2<CR>gv=gv'", options)
keymap("n", "J", ":m .+1<CR>=='", options)
keymap("n", "K", ":m .-2<CR>=='", options)

-- stay in the the middle while searching or moving
keymap("n", "<C-d>", "<C-d>zz", options)
keymap("n", "<C-u>", "<C-u>zz", options)
keymap("n", "n", "nzzzv", options)
keymap("n", "N", "Nzzzv", options)

-- diagnostic keymaps
keymap(
  "n",
  "[d",
  vim.diagnostic.goto_prev,
  { desc = "Go to previous [D]iagnostic message" }
)
keymap(
  "n",
  "]d",
  vim.diagnostic.goto_next,
  { desc = "Go to next [D]iagnostic message" }
)
keymap(
  "n",
  "<leader>e",
  vim.diagnostic.open_float,
  { desc = "Show diagnostic [E]rror messages" }
)
keymap(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostic [Q]uickfix list" }
)

-- split navigation easier, use CTRL+<hjkl> to switch between windows
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- highlight for a moment selecction when yanking (copying) text
-- visual confirmation of operation
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})