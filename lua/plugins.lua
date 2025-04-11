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

    -- directional indication of cursor jumps, neovide alike feedback
    -- it works nicely even with native kitty cursor tracking
    {
        "gen740/SmoothCursor.nvim",
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
                type = "split",   -- split window
                relative = "win", -- relative to current window
                position = "right",
                size = 0.3,
            },
        }, -- for default options, refer to the configuration section for custom setup.
    },

    -- -----------------
    -- Coding assistance
    -- -----------------

    -- experimental
    -- {
    --     "ggml-org/llama.vim",
    -- },

    -- lsp configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- mason integration, LSPs, formatters and linters management
            {
                "williamboman/mason.nvim",
                dependencies = {
                    { "williamboman/mason-lspconfig.nvim" },
                    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
                },
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

                    -- Supermaven
                    -- (NOTE: This is not replated to cmp but it registeres as a
                    -- completion source thus in not intrusive, testing for now,
                    -- for now results are much more comprehensive than with copilot)
                    {
                        "supermaven-inc/supermaven-nvim",
                        config = function()
                            require("supermaven-nvim").setup({
                                -- disables inline completion for use exclusively with cmp
                                disable_inline_completion = true,
                            })
                        end,
                    },

                    -- MCPHub
                    -- (NOTE: this is not a completion source but a tool to
                    -- interact with the MCPHub server and simplify the
                    -- interaction with it)
                    {
                        "ravitemer/mcphub.nvim",
                        dependencies = {
                            "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
                        },
                        -- comment the following line to ensure hub will be ready at the earliest
                        cmd = "MCPHub",                          -- lazy load by default
                        build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
                        -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
                        -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
                        config = function()
                            require("mcphub").setup({
                                -- This sets vim.g.mcphub_auto_approve to false by default (can also be toggled from the HUB UI with `ga`)
                                auto_approve = false,
                            })
                        end,
                    },

                    -- Cursor alike experience of AI Chat, althgought copilot
                    -- was a good starter, beeing model independent is much more
                    -- much more powerful due to dynamic industry changes and
                    -- can be used offline with ollama
                    {
                        "yetone/avante.nvim",
                        event = "VeryLazy",
                        lazy = false,
                        version = false, -- set this if you want to always pull the latest change
                        opts = {
                            default = {
                                embed_image_as_base64 = false,
                                prompt_for_file_name = false,
                                drag_and_drop = {
                                    insert_mode = true,
                                },
                            },
                            behaviour = {
                                auto_suggestions = false, -- Experimental stage
                                auto_set_highlight_group = true,
                                auto_set_keymaps = true,
                                auto_apply_diff_after_generation = false,
                                support_paste_from_clipboard = true,
                                minimize_diff = true,         -- Whether to remove unchanged lines when applying a code block
                                enable_token_counting = true, -- Whether to enable token counting. Default to true.
                            },
                            hints = { enabled = true },
                            disabled_tools = { -- Tools are disabled due to overlap with MCP capabilities
                                "list_files",  -- Built-in file operations
                                "search_files",
                                "read_file",
                                "create_file",
                                "rename_file",
                                "delete_file",
                                "create_dir",
                                "rename_dir",
                                "delete_dir",
                                "bash", -- Built-in terminal access
                            },
                            -- the provider to use for the chat, for possible values see `:h avante`
                            -- "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | "ollama"
                            provider = "gemini",
                            auto_suggestions_provider = "ollama",
                            gemini = {
                                model = "gemini-2.5-pro-exp-03-25",
                                temperature = 0.5,
                                max_tokens = 4096,
                            },
                            claude = {
                                endpoint = "https://api.anthropic.com",
                                model = "claude-3-5-sonnet-20241022",
                                temperature = 0,
                                max_tokens = 4096,
                            },
                            ollama = {
                                endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
                                model = "deepseek-r1:latest",
                                disable_tools = true,
                            },
                            vendors = {
                                deepseek = {
                                    __inherited_from = "openai",
                                    api_key_name = "DEEPSEEK_API_KEY",
                                    endpoint = "https://api.deepseek.com",
                                    model = "deepseek-coder",
                                },
                                perplexity = {
                                    __inherited_from = "openai",
                                    api_key_name = "PERPLEXITY_API_KEY",
                                    endpoint = "https://api.perplexity.ai",
                                    model = "llama-3.1-sonar-large-128k-online",
                                },
                                openrouter = {
                                    __inherited_from = "openai",
                                    endpoint = "https://openrouter.ai/api/v1",
                                    api_key_name = "OPENROUTER_API_KEY",
                                    model = "deepseek/deepseek-chat-v3-0324:free",
                                },
                            },
                            windows = {
                                position = "right",  -- the position of the sidebar
                                width = 30,          -- default % based on available width
                                sidebar_header = {
                                    enabled = false, -- true, false to enable/disable the header
                                    align = "right", -- left, center, right for title
                                    rounded = false,
                                },
                                edit = {
                                    border = "rounded",
                                    start_insert = true, -- Start insert mode when opening the edit window
                                },
                                ask = {
                                    floating = false,    -- Open the 'AvanteAsk' prompt in a floating window
                                    start_insert = true, -- Start insert mode when opening the ask window, only effective if floating = true.
                                    border = "rounded",
                                },
                            },
                        },
                        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
                        build = "make",
                        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
                        dependencies = {
                            "nvim-treesitter/nvim-treesitter",
                            "stevearc/dressing.nvim",
                            "nvim-lua/plenary.nvim",
                            "MunifTanjim/nui.nvim",
                            --- The below dependencies are optional,
                            "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
                            "nvim-telescope/telescope.nvim", -- for fileselector
                            "hrsh7th/nvim-cmp",              -- for completion of avante commands
                            -- "zbirenbaum/copilot.lua", -- for providers='copilot'
                            {
                                "zbirenbaum/copilot-cmp",
                                event = "InsertEnter",
                                config = function()
                                    require("copilot_cmp").setup()
                                end,
                                dependencies = {
                                    "zbirenbaum/copilot.lua",
                                    cmd = "Copilot",
                                    config = function()
                                        require("copilot").setup({
                                            suggestion = { enabled = true },
                                            panel = { enabled = false },
                                        })
                                    end,
                                },
                            },
                            {
                                -- support for image pasting
                                "HakonHarnes/img-clip.nvim",
                                event = "VeryLazy",
                                opts = {
                                    -- recommended settings
                                    default = {
                                        embed_image_as_base64 = false,
                                        prompt_for_file_name = false,
                                        drag_and_drop = {
                                            insert_mode = true,
                                        },
                                        -- required for Windows users
                                        use_absolute_path = true,
                                    },
                                },
                            },
                            {
                                -- for markdown rendering inside chat pane
                                "MeanderingProgrammer/render-markdown.nvim",
                                opts = {
                                    file_types = { "Avante", "markdown" },
                                },
                                ft = { "Avante", "markdown" },
                            },
                        },
                        -- config = function()
                        --     require("avante").setup({
                        --         -- system_prompt as function ensures LLM always has latest MCP server state
                        --         -- This is evaluated for every message, even in existing chats
                        --         system_prompt = function()
                        --             local hub =
                        --                 require("mcphub").get_hub_instance()
                        --             return hub:get_active_servers_prompt()
                        --         end,
                        --         -- Using function prevents requiring mcphub before it's loaded
                        --         custom_tools = function()
                        --             return {
                        --                 require("mcphub.extensions.avante").mcp_tool(),
                        --             }
                        --         end,
                        --     })
                        -- end,
                    },
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
                dependencies = {
                    "nvim-treesitter",
                },
                event = "InsertEnter",
            },
            -- treesitter wisely add "end" in ruby, Lua, Vimscript, etc.
            {
                "RRethy/nvim-treesitter-endwise",
                dependencies = {
                    "nvim-treesitter",
                },
                event = "InsertEnter",
            },
        },
    },

    -- restarting LSP servers based on window focus, keeping neovim fast
    {
        "hinell/lsp-timeout.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
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
