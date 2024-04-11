local actions = require("telescope.actions")
local map = vim.keymap.set

require("telescope").setup({
  defaults = {
    path_display = { "smart" },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({ winblend = 10 }),
    },
  },
})

-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "neoclip")
pcall(require("telescope").load_extension, "luasnip")
pcall(require("telescope").load_extension, "noice")

local builtin = require("telescope.builtin")

map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
map(
  "n",
  "<leader>ss",
  builtin.builtin,
  { desc = "[S]earch [S]elect Telescope" }
)
map(
  "n",
  "<leader>sw",
  builtin.grep_string,
  { desc = "[S]earch current [W]ord" }
)
map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
map(
  "n",
  "<leader>s.",
  builtin.oldfiles,
  { desc = '[S]earch Recent Files ("." for repeat)' }
)
map(
  "n",
  "<leader>sp",
  "<cmd>lua require'telescope'.extensions.luasnip.luasnip()<CR>",
  { desc = "[S]earch [C]lipboard" }
)
map(
  "n",
  "<leader>sc",
  "<cmd>lua require'telescope'.extensions.neoclip.default()<CR>",
  { desc = "[S]earch [C]lipboard" }
)
map(
  "n",
  "<leader><leader>",
  builtin.buffers,
  { desc = "[ ] Find existing buffers" }
)

-- Slightly advanced example of overriding default behavior and theme
map("n", "<leader>/", function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

-- It's also possible to pass additional configuration options.
map("n", "<leader>s/", function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "[S]earch [/] in Open Files" })

-- Shortcut for searching your Neovim configuration files
map("n", "<leader>sn", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })
