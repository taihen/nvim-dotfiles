local defaults = {
  auto_close = false, -- auto close when there are no items
  auto_open = false, -- auto open when there are items
  auto_preview = true, -- automatically open preview when on an item
  auto_refresh = true, -- auto refresh when open
  focus = false, -- Focus the window when opened
  restore = true, -- restores the last location in the list when opening
  follow = true, -- Follow the current item
  indent_guides = true, -- show indent guides
  max_items = 200, -- limit number of items that can be displayed per section
  multiline = true, -- render multi-line messages
  pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
  win = {}, -- window options for the results window. Can be a split or a floating window.
  -- Window options for the preview window. Can be a split, floating window,
  -- or `main` to show the preview in the main editor window.
  preview = { type = "preview window" },
  -- Throttle/Debounce settings. Should usually not be changed.
  throttle = {
    refresh = 20, -- fetches new data when needed
    update = 10, -- updates the window
    render = 10, -- renders the window
    follow = 10, -- follows the current item
    preview = { ms = 100, debounce = true }, -- shows the preview for the current item
  },
  keys = {
    ["?"] = "help",
    r = "refresh",
    R = "toggle_refresh",
    q = "close",
    o = "jump_close",
    ["<esc>"] = "cancel",
    ["<cr>"] = "jump",
    ["<2-leftmouse>"] = "jump",
    ["<c-s>"] = "jump_split",
    ["<c-v>"] = "jump_vsplit",
    -- go down to next item (accepts count)
    -- j = "next",
    ["}"] = "next",
    ["]]"] = "next",
    -- go up to prev item (accepts count)
    -- k = "prev",
    ["{"] = "prev",
    ["[["] = "prev",
    i = "inspect",
    p = "preview",
    P = "toggle_preview",
    zo = "fold_open",
    zO = "fold_open_recursive",
    zc = "fold_close",
    zC = "fold_close_recursive",
    za = "fold_toggle",
    zA = "fold_toggle_recursive",
    zm = "fold_more",
    zM = "fold_close_all",
    zr = "fold_reduce",
    zR = "fold_open_all",
    zx = "fold_update",
    zX = "fold_update_all",
    zn = "fold_disable",
    zN = "fold_enable",
    zi = "fold_toggle_enable",
  },
  modes = {
    symbols = {
      desc = "document symbols",
      mode = "lsp_document_symbols",
      focus = false,
      win = { position = "right" },
      filter = {
        -- remove Package since luals uses it for control flow structures
        ["not"] = { ft = "lua", kind = "Package" },
        any = {
          -- all symbol kinds for help / markdown files
          ft = { "help", "markdown" },
          -- default set of symbol kinds
          kind = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            "Property",
            "Struct",
            "Trait",
          },
        },
      },
    },
  },
  -- stylua: ignore
  icons = {
    ---@type trouble.Indent.symbols
    indent        = {
      top         = "│ ",
      middle      = "├╴",
      last        = "└╴",
      -- last          = "-╴",
      -- last       = "╰╴", -- rounded
      fold_open   = " ",
      fold_closed = " ",
      ws          = "  ",
    },
    folder_closed = " ",
    folder_open   = " ",
    kinds         = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      String        = " ",
      Struct        = "󰆼 ",
      TypeParameter = " ",
      Variable      = "󰀫 ",
    },
  },
}

local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open

-- Use this to add more results without clearing the trouble list
local add_to_trouble = require("trouble.sources.telescope").add

local telescope = require("telescope")

telescope.setup({
  defaults = {
    mappings = {
      i = { ["<c-t>"] = open_with_trouble },
      n = { ["<c-t>"] = open_with_trouble },
    },
  },
  modes = {
    preview_float = {
      mode = "diagnostics",
      preview = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        position = { 0, -2 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
      },
    },
  },
})
