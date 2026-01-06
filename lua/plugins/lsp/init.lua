-- LSP configuration: mason, lspconfig, and tools
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            {
                "hinell/lsp-timeout.nvim",
                dependencies = { "neovim/nvim-lspconfig" },
            },
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

            -- LspAttach autocmd for buffer-local keymaps
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = keymaps.on_attach,
            })

            -- LSP timeout configuration (5 minutes of inactivity)
            vim.g.lspTimeoutConfig = {
                stopTimeout = 1000 * 60 * 5, -- 5 minutes
                startTimeout = 1000 * 10, -- 10 seconds
                ignoredServers = {},
                events = {
                    "BufEnter",
                    "CursorHold",
                    "CursorHoldI",
                    "FocusGained",
                    "FocusLost",
                },
            }

            -- LSP capabilities (extended with nvim-cmp)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend(
                "force",
                capabilities,
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

            -- Configure LSP servers
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers.servers[server_name] or {}
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
        end,
    },
}
