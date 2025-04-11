-- autocommands

-- locals
local cmd = vim.cmd
local create_cmd = vim.api.nvim_create_user_command

-- create a background toggling command, used for light/dark theme switching
create_cmd("ToggleBackground", function()
    if vim.o.background == "dark" then
        vim.cmd("set bg=light")
    else
        vim.cmd("set bg=dark")
    end
end, {})

cmd([[
if has("autocmd")
  augroup redhat
  autocmd!
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  augroup END
endif
]])

-- turn on spellchecking for some file types
cmd([[ autocmd FileType gitcommit setlocal spell ]])
cmd([[ autocmd FileType markdown setlocal spell ]])
cmd([[ autocmd FileType text setlocal spell ]])
cmd([[ autocmd FileType wiki setlocal spell ]])

-- predefined column eol mark / gruvbox themed
cmd([[ autocmd VimEnter * highlight ColorColumn guibg=#3c3836]])

-- wrap automatically for markdown files
cmd([[autocmd FileType markdown set tw=80 wrap]])

-- change netrw nested list style
cmd("let g:netrw_liststyle = 3")

-- autocommands END
