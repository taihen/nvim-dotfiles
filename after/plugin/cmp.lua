local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

luasnip.config.setup({})

-- Command line completions
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
    experimental = {
        ghost_text = true,
    },
})

cmp.setup.cmdline(";", {
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

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = { completeopt = "menu,menuone,noinsert,preview" },

    -- For an understanding of why these mappings were
    -- chosen, you will need to read `:help ins-completion`
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    mapping = cmp.mapping.preset.insert({
        -- Scroll the documentation window [b]ack / [f]orward
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Accept (enter) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ["<C-Space>"] = cmp.mapping.complete({}),

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
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

        -- More prevelant use of TAB
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

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "treesitter" },
        { name = "buffer" },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "spell" },
        { name = "emoji" },
        { name = "calc" },
        { name = "git" },
        { name = "render-markdown" }, -- markdown plugin
    },
    experimental = {
        ghost_text = true,
    },
    formatting = {
        format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_chat = "...",
        }),
    },
})
