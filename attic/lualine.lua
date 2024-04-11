-- returns LSP clients attached to buffer
local clients_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.buf_get_clients(bufnr)
  if next(clients) == nil then
    return ""
  end

  local x = {}
  for _, client in pairs(clients) do
    table.insert(x, client.name)
  end
  return "\u{f085} " .. table.concat(x, "|")
end

local lazy_status = require("lazy.status")

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "gruvbox",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_d = { "filename" },
    lualine_x = {
      {
        lazy_status.updates,
        cond = lazy_status.has_updates,
      },
      clients_lsp,
      "encoding",
      "fileformat",
      {
        "filetype",
        icon_only = true,
      },
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})
