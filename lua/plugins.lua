return {
    -- -------
    -- visuals
    -- -------

    -- highlight todo, notes, etc in comments as marks
    -- depends at best on plenary, but adding devicons and trouble for
    -- integrations
    -- an example usage is this document itself, note usage of "TODO:" and "NOTE:"
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "folke/trouble.nvim",
        },
        opts = { signs = true },
    },

    -- as there is no status line in this nvim configuration, while working in
    -- multiple panes/buffers it is usefull to expose current buffer/file name
    -- and some workspace diagnostics, right left corner
    {
        "b0o/incline.nvim",
        config = function()
            require("incline").setup()
        end,
        event = "VeryLazy",
        dependencies = {
            -- optional for icons
            "nvim-tree/nvim-web-devicons",
            -- optional for diagnostics
            {
                "lewis6991/gitsigns.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                },
            },
        },
    },

    -- general colorizer without external deps
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
    },

    -- extended core experience, enhances the default Neovim UI for
    -- `vim.ui.select`, `vim.ui.input`, `vim.diagnostic` and more
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- `noice.nvim` completely replaces the UI for `vim.notify`, messages,
    -- and the cmdline
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                "rcarriga/nvim-notify",
                keys = {
                    {
                        "<leader>un",
                        function()
                            require("notify").dismiss({
                                silent = true,
                                pending = true,
                            })
                        end,
                        desc = "Dismiss All Notifications",
                    },
                },
                opts = {
                    stages = "fade_in_slide_out",
                    timeout = 5000,
                    max_height = function()
                        return math.floor(vim.o.lines * 0.75)
                    end,
                    max_width = function()
                        return math.floor(vim.o.columns * 0.75)
                    end,
                    on_open = function(win)
                        vim.api.nvim_win_set_config(win, { zindex = 100 })
                    end,
                },
                init = function()
                    -- when noice is not enabled, install notify on VeryLazy
                    vim.notify = require("notify")
                end,
            },
        },
    },

    -- automatically highlighting other uses of the word under the cursor
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            require("illuminate").configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, {
                    desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference",
                    buffer = buffer,
                })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })
        end,
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },

    -- after decade with solarized, since 2018 with gruvbox, in particular
    -- with material shade from 2024, lazy disabled, should load right away
    -- together with command :ToggleBackground and key mapping <leader>b
    -- switches between light and dark version, those are added to cmd.lua and
    -- keys.lua as are not specifics to only this plugin
    -- the automatic switch between light and dark works well with kitty
    -- terminal, this might sync with systems dark mode settings
    -- check out "selenebun/gruvbox-material-kitty" for matching kitty theme
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            -- TODO: hashed out settings return errors, need to check
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_background = "original"
            vim.g.gruvbox_material_foreground = "original"
            -- not using statusline anymore
            -- vim.g.gruvbox_material_statusline_style = "original"
            vim.g.gruvbox_material_disable_italic_comment = 0
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_cursor = "auto"
            --  0 no transparency, 1 background and bars, 2 full transparency
            --  needs to be set to 0 to support light/dark switching
            vim.g.gruvbox_material_transparent_background = 1
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_visual = "grey background"
            -- vim.g.gruvbox_material_menu_selection_background = "gray"
            vim.g.gruvbox_material_sign_column_background = "none"
            vim.g.gruvbox_material_spell_foreground = "none"
            vim.g.gruvbox_material_spell_background = "blue"
            vim.g.gruvbox_material_ui_contrast = "low"
            vim.g.gruvbox_material_show_eob = 1
            vim.g.gruvbox_material_float_style = "bright"
            vim.g.gruvbox_material_diagnostic_text_highlight = 1
            vim.g.gruvbox_material_diagnostic_line_highlight = 0
            vim.g.gruvbox_material_diagnostic_virtual_text = "gray"
            -- vim.g.gruvbox_material_current_word = "gray background"
            vim.g.gruvbox_material_disable_terminal_colors = 1
            vim.g.gruvbox_material_statusline_style = "default"
            vim.g.gruvbox_material_lightline_disable_bold = 0
            vim.g.gruvbox_material_better_performance = 1
            -- set automatically by auto-dark-mode
            -- vim.cmd.colorscheme("gruvbox-material")
        end,
    },

    -- this is handy for switching between dark and light mode automatically
    -- toggether with kitty terminal which switches between light and dark does
    -- not require any extra configuration nor user intervention
    -- disable at runtime with require('auto-dark-mode').disable()
    {
        "f-person/auto-dark-mode.nvim",
        -- TODO: flashing on startup
        -- https://github.com/f-person/auto-dark-mode.nvim/issues/17
        opts = {
            update_interval = 1000,
            falback = "light",
            set_light_mode = function()
                vim.api.nvim_set_option_value("background", "light", {})
                vim.cmd.colorscheme("gruvbox-material")
            end,
            set_dark_mode = function()
                vim.api.nvim_set_option_value("background", "dark", {})
                vim.cmd.colorscheme("gruvbox-material")
            end,
        },
    },

    -- -----------
    -- handy tools
    -- -----------

    -- collection of various small independent plugins/modules slowly ingested
    -- by core neovim currently using:
    -- * mini.surround as a replacement for vim-surround
    -- * mini.ai extends motions
    -- * mini.indentscope visualizes indent scope (additionally to indent-blankline)
    -- * mini.trailspace trims trailing whitespaces on save
    -- * mini.icons for file icons
    {
        "echasnovski/mini.nvim",
        config = function()
            -- collection of small utils

            -- advanced object manipulation
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- add/delete/replace surroundings (brackets, quotes, etc.)
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require("mini.surround").setup()

            -- visualize scope/indent with animated vertical line
            -- - [i    - goto top of indent
            -- - ]i    - goto bottom of indent
            require("mini.indentscope").setup()

            -- trailing whitespace handling
            require("mini.trailspace").setup()
        end,
    },

    -- autoclosing pairs
    -- TODO: probably can be replaced with mini.pairs
    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        config = true,
    },

    -- detect tabstop and shiftwidth automatically based on file and project
    {
        "tpope/vim-sleuth",
    },

    -- code commenting for multiple formats, successor to vim-commenter with
    -- treesitter integration
    -- NOTE: probably can be replaced with mini.comment which should land in
    -- neovim 0.10 natively
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = true,
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
    },

    -- fuzzy finder and more
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        event = "VimEnter",
        dependencies = {
            {
                "nvim-lua/plenary.nvim",
            },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            {
                "nvim-telescope/telescope-ui-select.nvim",
            },
            {
                "nvim-tree/nvim-web-devicons",
                enabled = vim.g.have_nerd_font,
            },
            -- register picker for fuzzy finder with pernament storage
            {
                "AckslD/nvim-neoclip.lua",
                dependencies = {
                    "kkharji/sqlite.lua",
                    "nvim-telescope/telescope.nvim",
                },
            },
            -- snippets fuzzy finder
            {
                "benfowler/telescope-luasnip.nvim",
            },
            -- terraform docs
            {
                "ANGkeith/telescope-terraform-doc.nvim",
            },
            {
                "cappyzawa/telescope-terraform.nvim",
            },
        },
    },

    -- key bindings discovery
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 3000
        end,
        opts = {},
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    -- indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPre", "BufNewFile" },
    },

    -- markdown viewing
    -- in terminal

    -- {
    --     "OXY2DEV/markview.nvim",
    --     lazy = false, -- Recommended
    --     ft = { "markdown" },
    --     opts = {
    --         file_types = { "markdown" },
    --     },
    --
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --         "nvim-tree/nvim-web-devicons",
    --     },
    -- },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            -- file_types = { "markdown" },
        },
        -- ft = { "markdown" },
    },

    -- in browser
    {
        "iamcco/markdown-preview.nvim",
        event = "VeryLazy",
        build = "cd app && npm install",
        ft = { "markdown" },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        keys = {
            {
                "<leader>mp",
                ":MarkdownPreview<CR>",
                mode = "n",
                desc = "[M]arkdown [P]review",
            },
        },
    },

    -- diagnostics helper
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xb",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>xw",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Workspace Diagnostics (Trouble)",
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xc",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
            {
                "<leader>xt",
                "<cmd>TodoTrouble<cr>",
                desc = "Todo List (Trouble)",
            },
        },
        opts = {
            position = "right",
            focus = true,
            use_diagnostic_signs = true,
            win = {
                type = "split", -- split window
                relative = "win", -- relative to current window
                position = "right",
                size = 0.3,
            },
        }, -- for default options, refer to the configuration section for custom setup.
    },

    -- -----------------
    -- Coding assistance
    -- -----------------

    -- lsp configuration
    -- TODO: should look in blink cmp in near future
    --
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- mason integration, LSPs, formatters and linters management
            {
                "mason-org/mason.nvim",
                dependencies = {
                    { "mason-org/mason-lspconfig.nvim" },
                    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
                },
            },

            -- restarting LSP servers based on window focus where those are
            -- needed keeping Neovim fast and responsive
            {
                "hinell/lsp-timeout.nvim",
            },

            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            { "folke/neodev.nvim", opts = {} },

            -- autocompletion
            {
                "hrsh7th/nvim-cmp",
                event = "InsertEnter",
                dependencies = {
                    { "hrsh7th/cmp-buffer" },
                    { "hrsh7th/cmp-path" },
                    { "hrsh7th/cmp-nvim-lsp" },
                    { "hrsh7th/cmp-nvim-lua" },
                    { "hrsh7th/cmp-emoji" },

                    -- git
                    { "petertriho/cmp-git" },

                    -- snippets
                    { "saadparwaiz1/cmp_luasnip" },
                    {
                        "L3MON4D3/LuaSnip",
                        build = (function()
                            -- Build Step is needed for regex support in snippets.
                            if
                                vim.fn.has("win32") == 1
                                or vim.fn.executable("make") == 0
                            then
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

                    -- LSP ncmp icons
                    { "onsails/lspkind.nvim" },

                    -- SchemaStore support
                    { "b0o/schemastore.nvim" },
                },
            },
        },
    },

    -- agentic assistance
    -- as I never got along with avante that I've used before and with the EOL
    -- of supermaven, which was fast and not intrusive I switched to sidekick
    -- with copilot which on one hand provides inline completion and on the
    -- other hand with cli agents
    {
        "folke/sidekick.nvim",
        opts = {
            cli = {
                mux = {
                    -- using zellij for general terminal mux and tmux
                    -- exclusively for sidekick
                    backend = "tmux",
                    enabled = true,
                },
            },
            nes = {
                enabled = true,
                debounce = 100,
                trigger = {
                    events = { "ModeChanged i:n", "TextChanged" },
                },
            },
        },
        keys = {
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply
                    -- it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-.>",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "Sidekick Toggle",
                mode = { "n", "t", "i", "x" },
            },
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "Sidekick Toggle CLI",
            },
            {
                "<leader>as",
                function()
                    -- require("sidekick.cli").select()
                    -- show only installed agents
                    require("sidekick.cli").select({
                        filter = { installed = true },
                    })
                end,
                desc = "Select CLI",
            },
            {
                "<leader>ad",
                function()
                    require("sidekick.cli").close()
                end,
                desc = "Detach a CLI Session",
            },
            {
                "<leader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}" })
                end,
                mode = { "x", "n" },
                desc = "Send This",
            },
            {
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                desc = "Send File",
            },
            {
                "<leader>av",
                function()
                    require("sidekick.cli").send({ msg = "{selection}" })
                end,
                mode = { "x" },
                desc = "Send Visual Selection",
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                mode = { "n", "x" },
                desc = "Sidekick Select Prompt",
            },
            -- Keybinding to open Claude directly
            {
                "<leader>ac",
                function()
                    require("sidekick.cli").toggle({
                        name = "claude",
                        focus = true,
                    })
                end,
                desc = "Sidekick Toggle Claude",
            },
        },
        dependencies = {
            -- (optional) for NES functionality
            {
                "zbirenbaum/copilot.lua",
                -- cmd = "Copilot",
                event = "InsertEnter",
                config = function()
                    require("copilot").setup({
                        panel = { enabled = false, auto_refresh = false },
                        -- disable copilot's native suggestions since we're using sidekick NES
                        suggestion = { enabled = false, auto_trigger = false },
                        -- node binary to use (if you manage node with nvm, update path)
                        copilot_node_command = "node",
                        server_opts_overrides = {},
                    })
                end,
            },
            -- (optional) picker functionality
            {
                "folke/snacks.nvim",
                priority = 1000,
                lazy = false,
                ---@type snacks.Config
                opts = {
                    -- default settings
                    -- refer to the configuration section below
                    bigfile = { enabled = true },
                    dashboard = { enabled = true },
                    explorer = { enabled = true },
                    indent = { enabled = true },
                    input = { enabled = true },
                    picker = { enabled = true },
                    notifier = { enabled = true },
                    quickfile = { enabled = true },
                    scope = { enabled = true },
                    scroll = { enabled = true },
                    statuscolumn = { enabled = true },
                    words = { enabled = true },
                },
            },
        },
    },

    -- treesitter configuration for syntax highlighting, indenting, etc
    -- it parses source code into syntax trees, enabling advanced text editing
    -- features
    -- * syntax-aware text selection
    -- * code folding
    -- * incremental selection
    -- * jump to definition
    -- * and more ...
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            -- treesitter autotags
            {
                "windwp/nvim-ts-autotag",
                event = "InsertEnter",
            },
            -- treesitter wisely add "end" in ruby, Lua, Vimscript, etc.
            {
                "RRethy/nvim-treesitter-endwise",
                event = "InsertEnter",
            },
            -- used mostly with sidekick
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                branch = "main",
            },
        },
    },

    -- formatting mostly, drop-in replacement for null-ls which I was happy with
    -- (TODO: should check out duo 'stevearc/conform.nvim' and 'nvim-lint',
    -- although it looks like none-ls project is far from dead as it is not only
    -- providing formatting)
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
