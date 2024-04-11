require("which-key").setup()
require("which-key").register({
  ["<leader>a"] = { name = "[A]I", _ = "which_key_ignore" },
  ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
  ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
  ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
  ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
  ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
  ["<leader>x"] = { name = "[X]trouble", _ = "which_key_ignore" },
})
