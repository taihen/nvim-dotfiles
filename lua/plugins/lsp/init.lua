-- LSP configuration: mason, lspconfig, and tools
--
-- Server setup uses the native vim.lsp.config() + vim.lsp.enable() API
-- (introduced in 0.11, preferred in 0.12+). nvim-lspconfig is kept as a
-- dependency solely for its lsp/ runtime directory, which Neovim auto-discovers
-- for server command/filetypes definitions. We no longer call lspconfig.setup().
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "luvit-meta/library", words = { "vim%.uv" } },
                    },
                },
            },
            { "Bilal2453/luvit-meta", lazy = true },
            { "b0o/schemastore.nvim" },
        },
        config = function()
            local servers = require("config.lsp.servers")
            local keymaps = require("config.lsp.keymaps")

            -- Diagnostic configuration (0.12: signs must be set here, not via :sign-define)
            vim.diagnostic.config({
                severity_sort = true,
                update_in_insert = false,
                float = { border = "rounded", source = "if_many" },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN]  = "",
                        [vim.diagnostic.severity.INFO]  = "",
                        [vim.diagnostic.severity.HINT]  = "",
                    },
                },
            })

            -- LspAttach autocmd for buffer-local keymaps
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = keymaps.on_attach,
            })

            -- LSP capabilities (extended with nvim-cmp)
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            -- Mason setup
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

            -- Install tools (LSP servers, formatters, linters)
            require("mason-tool-installer").setup({
                ensure_installed = servers.ensure_installed,
            })

            -- Ensure LSP server binaries are installed via Mason.
            -- No handlers: server configuration is done below via vim.lsp.config().
            require("mason-lspconfig").setup()

            -- Configure and enable each server using the native LSP API.
            -- vim.lsp.config() registers settings; vim.lsp.enable() activates
            -- the server when a matching filetype is opened.
            for server_name, server_config in pairs(servers.servers) do
                local config = vim.tbl_deep_extend("force", {}, server_config)
                config.capabilities = vim.tbl_deep_extend(
                    "force",
                    capabilities,
                    config.capabilities or {}
                )
                vim.lsp.config(server_name, config)
                vim.lsp.enable(server_name)
            end
        end,
    },
}
