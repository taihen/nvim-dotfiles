-- enable treesitter buildin folding
local opt = vim.opt
local api = vim.api
local M = {}

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99

-- treesitter folds all by default, undo this
-- this function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command("augroup " .. group_name)
    api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
      api.nvim_command(command)
    end
    api.nvim_command("augroup END")
  end
end

-- autocommand to run after a file/buffer is opened to open all folds
local autoCommands = {
  -- other autocommands
  open_folds = {
    { "BufReadPost,FileReadPost", "*", "normal zR" },
  },
}

require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

M.nvim_create_augroups(autoCommands)
