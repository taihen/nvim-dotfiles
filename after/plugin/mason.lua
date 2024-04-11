-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend(
  "force",
  capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local servers = {
  -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
  ansiblels = {},
  bashls = {
    filetypes = {
      "bash",
      "sh",
    },
  },
  dockerls = {},
  docker_compose_language_service = {},
  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        experimentalPostfixCompletions = true,
        staticcheck = true,
        usePlaceholders = true,
      },
    },
  },
  tsserver = {},
  terraformls = {
    settings = {
      ["terraform-ls"] = {
        experimentalFeatures = {
          prefillRequiredFields = true,
        },
      },
    },
  },
  helm_ls = {},
  lua_ls = {
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = { disable = { "missing-fields" } },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        schemaStore = {
          -- Disable built-in schemaStore support of yamlls if you want to use
          -- schemaStore plugin and its advanced options like `ignore`.
          enable = false,
          url = "",
        },
        trace = {
          server = "verbose",
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
  },
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
}

require("mason").setup({
  ui = {
    border = "none",
    check_outdated_packages_on_open = true,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
})

-- list provided to mason-tool-installer, mostly used with null-ls
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  "stylua", -- lua formatter
  "tflint", -- hcl linting
  "trivy", -- hcl scanning
  "prettier", -- multiple formats
  "isort", -- python formatter
  "black", -- python formatter
  "taplo", -- toml formatter
  "golines", -- go formatter
  "gofumpt", -- go formatter
  "goimports-reviser", -- go imports formatter
  "editorconfig-checker", -- checker for editorconfig
  "yq", -- yaml formatter
  "yamlfix", -- yaml linter
  "yamlfmt", -- yaml formatter
  "vale", -- language formatter
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("mason-lspconfig").setup({
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      -- This handles overriding only values explicitly passed
      -- by the server configuration above. Useful when disabling
      -- certain features of an LSP (for example, turning off formatting for tsserver)
      server.capabilities = vim.tbl_deep_extend(
        "force",
        {},
        capabilities,
        server.capabilities or {}
      )
      require("lspconfig")[server_name].setup(server)
    end,
  },
})
