local cmd = vim.cmd

-- autocommands
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

-- autocommands END
