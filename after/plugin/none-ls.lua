local api = vim.api
local lsp = vim.lsp

require("null-ls").setup({
  debug = false,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          lsp.buf.format()
        end,
      })
    end
  end,

  sources = {
    -- no trailing spaces and lines
    require("null-ls").builtins.diagnostics.trail_space,
    -- spelling
    require("null-ls").builtins.completion.spell,
    require("null-ls").builtins.hover.dictionary,
    -- shell
    require("null-ls").builtins.formatting.shellharden, -- shell hardening script formatting
    require("null-ls").builtins.formatting.shfmt, -- shell script formatting
    -- git
    require("null-ls").builtins.code_actions.gitsigns, -- shell script code actions
    -- markdown
    require("null-ls").builtins.formatting.prettier.with({
      extra_args = { "--print-width 80" },
      filetypes = { "html", "json", "yaml", "markdown" },
    }),
    -- lua
    require("null-ls").builtins.formatting.stylua, -- lua formatting
    -- go
    require("null-ls").builtins.formatting.gofumpt,
    require("null-ls").builtins.formatting.goimports_reviser,
    require("null-ls").builtins.formatting.golines,
    -- write
    require("null-ls").builtins.diagnostics.vale, -- syntax aware formatter
    -- terraform
    require("null-ls").builtins.diagnostics.trivy, -- security scanning
    require("null-ls").builtins.diagnostics.terraform_validate, -- validate config
    require("null-ls").builtins.formatting.terraform_fmt, -- formatting
    -- python
    require("null-ls").builtins.formatting.black,
    -- yaml
    require("null-ls").builtins.formatting.yamlfix,
    require("null-ls").builtins.formatting.yamlfmt,
  },
})
