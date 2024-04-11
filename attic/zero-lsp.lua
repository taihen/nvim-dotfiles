-- Load lspconfig module
local lspconfig = require("lspconfig")

-- Configure lsp-zero
local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)

-- additional completion
lspconfig.intelephense.setup({})

-- Terraform Clients
lspconfig.terraformls.setup({})
lspconfig.tflint.setup({})

-- This is buildin schemaStore validator, that is not use in favour of schemaStore client
-- lsp.configure("yamlls", {
-- 	filetypes = { "yaml", "yaml.docker-compose", "yml" },
-- 	settings = {
-- 		yaml = {
-- 			format = {
-- 				enable = true,
-- 			},
-- 			schemaStore = {
-- 				enable = true,
-- 			},
-- 			schemas = {
-- 				kubernetes = "*.yaml",
-- 				["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
-- 				["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
-- 				["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
-- 				["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
-- 				["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
-- 				["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
-- 				["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
-- 				["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
-- 				["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
-- 				["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
-- 				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
-- 				["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
-- 			},
-- 		},
-- 	},
-- })

-- schemaStore clients
lsp.configure("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        -- Disable built-in schemaStore support of yamlls if you want to use
        -- schemaStore plugin and its advanced options like `ignore`.
        enable = false,
      },
      schemas = require("schemastore").yaml.schemas({
        extra = {
          description = "ArgoCD Schemas",
          url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
          name = "argocd.json",
          fileMatch = {
            "apps/ApplicationClusterStack.yaml",
            "ApplicationSet.yaml",
            "apps.yaml",
          },
        },
      }),
    },
  },
})

lsp.configure("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

-- For this to work you need to install these plugins:
-- hrsh7th/cmp-path
-- hrsh7th/cmp-nvim-lsp
-- hrsh7th/cmp-buffer
-- saadparwaiz1/cmp_luasnip
-- rafamadriz/friendly-snippets

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local lspkind = require("lspkind")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  sources = {
    { name = "path" },
    { name = "emoji" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "buffer", keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
  },
  mapping = {
    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp_action.luasnip_supertab(),
    ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
  },
  preselect = "item",
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = require("lspkind").cmp_format({
      mode = "symbol_text", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
    }),
  },
})
