-- nvim-cmp completion configuration with Sidekick integration
return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "ray-x/cmp-treesitter",
            "hrsh7th/cmp-nvim-lua",
            "f3fora/cmp-spell",
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-calc",
            "petertriho/cmp-git",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")

            luasnip.config.setup({})

            -- Command line completions for search
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
                experimental = {
                    ghost_text = true,
                },
            })

            -- Command line completions for commands
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
                experimental = {
                    ghost_text = true,
                },
            })

            -- Main completion setup
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert,preview" },
                mapping = cmp.mapping.preset.insert({
                    -- Scroll the documentation window
                    -- NOTE: These <c-f>/<c-b> mappings don't conflict with noice's LSP doc scrolling
                    -- because noice uses expr=true and falls through when not in LSP hover context
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    -- Accept completion (auto-import if LSP supports it, expand snippets)
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger completion
                    ["<C-Space>"] = cmp.mapping.complete({}),

                    -- Snippet navigation (forward/backward)
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),

                    -- Smart Tab: Sidekick NES → completion → snippet → fallback
                    ["<Tab>"] = function(fallback)
                        -- Check sidekick NES first (for AI-powered next edit suggestions)
                        local ok, sidekick = pcall(require, "sidekick")
                        if ok and sidekick.nes_jump_or_apply() then
                            return
                        elseif cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end,
                    ["<S-Tab>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end,
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "treesitter" },
                    { name = "buffer" },
                    { name = "nvim_lua" },
                    { name = "spell" },
                    { name = "emoji" },
                    { name = "calc" },
                    { name = "git" },
                },
                experimental = {
                    ghost_text = true,
                },
                formatting = {
                    format = lspkind.cmp_format({
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
            })
        end,
    },
}
