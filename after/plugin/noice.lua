require("noice").setup({
    routes = {
        {
            view = "mini",
            filter = { event = "msg_showmode" },
        },
    },
    notify = {
        view = "mini",
        enabled = true,
    },
    lsp = {
        hover = {
            enabled = true,
            silent = true, -- set to true to not show a message if hover is not available
            opts = {}, -- merged with defaults from documentation
        },
        progress = {
            enabled = true,
        },
        message = {
            enabled = true,
        },
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
        signature = {
            enabled = true,
        },
    },
    cmdline = {
        view = "cmdline",
        enabled = true,
    },
    messages = {
        enabled = true, -- enables the Noice messages UI, virtualtext does not work without it
        view = "mini",
        view_error = "mini", -- view for errors
        view_warn = "mini", -- view for warnings
        view_history = "mini", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        -- long_message_to_split = true, -- long messages will be sent to a split
        -- inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    popupmenu = {
        backend = "cmp",
    },
    commands = {
        last = {
            view = "mini",
        },
        errors = {
            view = "mini",
        },
        history = {
            view = "mini",
        },
    },
})
