-- locals
local vim = vim
local api = vim.api
local opt = vim.opt
local wo = vim.wo

-- no mouse in nvim
opt.mouse = ""

-- nerd font installed
vim.g.have_nerd_font = true

-- italics for comments
api.nvim_set_hl(0, "Comment", { italic = true })

-- add window title to the name of the file
opt.title = true

-- show relevant hidden characters by default
opt.list = true
opt.listchars = { eol = "↲", tab = "▸ ", trail = "·" }

-- don't show the mode, since it's already in the status line
-- not relevant currently as there is cmdheight of 0
vim.opt.showmode = false

-- do wrap long lines
opt.wrap = true

-- automatically ident new lines
opt.autoindent = true

-- automatically break ident
opt.breakindent = true

-- highlight the current line
opt.cursorline = true

-- number of context lines to see above and below the cursor while scroling
opt.scrolloff = 10
opt.sidescrolloff = 10

-- insert 2 spaces for a tab
opt.tabstop = 2
opt.softtabstop = 2

-- the number of spaces inserted for each indentation
opt.shiftwidth = 2

-- expand tab to spaces
opt.expandtab = true

-- allows neovim to access the system clipboard
opt.clipboard = "unnamedplus"

-- case insensitive searching UNLESS /C or capital in search
opt.ignorecase = true

-- ignore 'ignorecase' if the search pattern contains upper case characters
opt.smartcase = true

-- incremental live completion with a split summary information is not needed
-- as folke/noice adds nice inlay hint
opt.inccommand = "nosplit"

-- set line number and relative number
wo.number = true
wo.relativenumber = true

-- set number column width to 2 {default 4}
wo.numberwidth = 2

-- force all horizontal splits to go below current window
opt.splitbelow = true

-- force all vertical splits to go to the right of current window
opt.splitright = true

-- keep scroll in the same relative cursor position when moving around
opt.splitkeep = "cursor"

-- so that `` is visible in markdown files
opt.conceallevel = 0

-- completeopt
opt.completeopt = "menuone,noinsert"

-- interval writing swap file to disk, mostly used for gitsigns
opt.updatetime = 50

-- additional colum for diagnostic
wo.signcolumn = "yes"

-- save undo history
opt.undofile = true
opt.undodir = vim.fn.expand("~/.sync/dot/.nvim/")

-- do not save when switching buffers
opt.hidden = true

-- color column
opt.colorcolumn = "80"

-- limit text width to match colorcolumn
opt.textwidth = 80

-- enable true (24-bit) colours in the terminal
opt.termguicolors = true

-- enable highlight search
opt.hlsearch = true

-- decrease update time
opt.updatetime = 250

-- decreate mapped sequence wait time, displays which-key sooner
opt.timeoutlen = 300

-- ensure utf8 across environments
vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencodings = "utf-8"

-- show last command in the status bar
opt.showcmd = false

-- remove dedicated space for cmd line
opt.cmdheight = 0
opt.laststatus = 0

-- backspacing over
opt.backspace = { "start", "eol", "indent" }
