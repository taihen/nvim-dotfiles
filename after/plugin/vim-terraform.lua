-- this used to be configuration for vim-terraform, but since I haven't used it
-- more than formatting I moved to general solution (null-ls)
local cmd = vim.cmd

cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])

-- cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
cmd([[autocmd BufRead,BufNewFile *.hcl,*.tf,*.tfvars set filetype=terraform]])
cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

-- add formatting call for lsp
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
