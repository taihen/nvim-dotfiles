-- fancy animation to recognize the direction of moving cursor

require("smoothcursor").setup({
  autostart = true,
  cursor = "", -- cursor shape (need nerd font)
  intervals = 35, -- tick interval
  linehl = nil, -- highlight sub-cursor line like 'cursorline', "CursorLine" recommended
  type = "default", -- define cursor movement calculate function, "default" or "exp" (exponential).
  fancy = {
    enable = true, -- enable fancy mode
    head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
    body = {
      { cursor = "", texthl = "SmoothCursorRed" },
      { cursor = "", texthl = "SmoothCursorOrange" },
      { cursor = "●", texthl = "SmoothCursorYellow" },
      { cursor = "●", texthl = "SmoothCursorGreen" },
      { cursor = "•", texthl = "SmoothCursorAqua" },
      { cursor = ".", texthl = "SmoothCursorBlue" },
      { cursor = ".", texthl = "SmoothCursorPurple" },
    },
    tail = { cursor = nil, texthl = "SmoothCursor" },
  },
  priority = 10, -- set marker priority
  speed = 25, -- max is 100 to stick to your current position
  texthl = "SmoothCursor", -- highlight group, default is { bg = nil, fg = "#FFD400" }
  threshold = 3,
  timeout = 3000,
})

-- changing the fancy cursor based on mode

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "ModeChanged" }, {
  callback = function()
    local current_mode = vim.fn.mode()
    if current_mode == "n" then
      vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#ffd400" })
      vim.fn.sign_define("smoothcursor", { text = "▷" })
    elseif current_mode == "v" then
      vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#bf616a" })
      vim.fn.sign_define("smoothcursor", { text = "" })
    elseif current_mode == "V" then
      vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#bf616a" })
      vim.fn.sign_define("smoothcursor", { text = "" })
    elseif current_mode == "�" then
      vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#bf616a" })
      vim.fn.sign_define("smoothcursor", { text = "" })
    elseif current_mode == "i" then
      vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#668aab" })
      vim.fn.sign_define("smoothcursor", { text = "" })
    end
  end,
})
