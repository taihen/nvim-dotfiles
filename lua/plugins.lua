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
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
                end,
                desc = "Next error/warning todo comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev({ keywords = { "ERROR", "WARNING" } })
                end,
                desc = "Previous error/warning todo comment",
            },
        },
    },

    -- as there is no status line in this nvim configuration, while working in
    -- multiple panes/buffers it is usefull to expose current buffer/file name
    -- and some workspace diagnostics, right left corner
    {
        "b0o/incline.nvim",
        config = function()
            local devicons = require("nvim-web-devicons")
            require("incline").setup({
                window = {
                    padding = 0,
                    margin = { horizontal = 0, vertical = 0 },
                },
                -- Enable hiding when only one window is visible
                hide = {
                    only_win = false,
                },
                -- Ignore specific filetypes
                ignore = {
                    buftypes = "special",
                    filetypes = {},
                    floating_wins = true,
                    unlisted_buffers = true,
                },
                render = function(props)
                    local filename = vim.fn.fnamemodify(
                        vim.api.nvim_buf_get_name(props.buf),
                        ":t"
                    )
                    if filename == "" then
                        filename = "[No Name]"
                    end

                    -- Get file type icon and color
                    local ft_icon, ft_color = devicons.get_icon_color(filename)
                    -- Fallback: try by filetype if filename method fails
                    if not ft_icon then
                        local ft = vim.bo[props.buf].filetype
                        ft_icon, ft_color =
                            devicons.get_icon_color_by_filetype(ft)
                    end

                    local function get_git_diff()
                        local icons =
                            { removed = "", changed = "", added = "" }
                        local signs = vim.b[props.buf].gitsigns_status_dict
                        local labels = {}
                        if signs == nil then
                            return labels
                        end
                        for name, icon in pairs(icons) do
                            if tonumber(signs[name]) and signs[name] > 0 then
                                table.insert(labels, {
                                    icon .. signs[name] .. " ",
                                    group = "Diff" .. name,
                                })
                            end
                        end
                        if #labels > 0 then
                            table.insert(labels, { "┊ " })
                        end
                        return labels
                    end

                    local function get_diagnostic_label()
                        local icons = {
                            error = "",
                            warn = "",
                            info = "",
                            hint = "",
                        }
                        local label = {}

                        for severity, icon in pairs(icons) do
                            local n = #vim.diagnostic.get(props.buf, {
                                severity = vim.diagnostic.severity[string.upper(
                                    severity
                                )],
                            })
                            if n > 0 then
                                table.insert(label, {
                                    icon .. n .. " ",
                                    group = "DiagnosticSign" .. severity,
                                })
                            end
                        end
                        if #label > 0 then
                            table.insert(label, { "┊ " })
                        end
                        return label
                    end

                    local function get_cursor_position()
                        -- Only show cursor position for the focused window
                        if props.focused then
                            local cursor =
                                vim.api.nvim_win_get_cursor(props.win)
                            local line = cursor[1]
                            local col = cursor[2] + 1
                            local total_lines =
                                vim.api.nvim_buf_line_count(props.buf)
                            local percentage =
                                math.floor((line / total_lines) * 100)

                            return {
                                string.format(
                                    "%d:%d %d%% ",
                                    line,
                                    col,
                                    percentage
                                ),
                                group = "Comment",
                            }
                        end
                        return ""
                    end

                    return {
                        { get_diagnostic_label() },
                        { get_git_diff() },
                        {
                            (ft_icon or "") .. " ",
                            guifg = ft_color,
                            guibg = "none",
                        },
                        {
                            filename .. " ",
                            gui = vim.bo[props.buf].modified and "bold,italic"
                                or "bold",
                        },
                        { "┊ " },
                        { get_cursor_position() },
                    }
                end,
            })
        end,
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },

    -- Git integration (extracted to lua/plugins/git.lua)
    { import = "plugins.git" },

    -- general colorizer without external deps
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        opts = {
            filetypes = { "*" },
            user_default_options = {
                RGB = true,
                RRGGBB = true,
                names = true,
                mode = "background",
                tailwind = false,
                virtualtext = "■",
            },
        },
    },


    -- `noice.nvim` completely replaces the UI for `vim.notify`, messages,
    -- and the cmdline
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- Enable useful presets
            presets = {
                bottom_search = true, -- classic bottom cmdline for search
                command_palette = true, -- position cmdline and popupmenu together
                long_message_to_split = true, -- long messages sent to split
                inc_rename = false, -- enables input dialog for inc-rename
                lsp_doc_border = true, -- add border to hover docs and signature help
            },

            -- Configure command line appearance
            cmdline = {
                enabled = true,
                view = "cmdline_popup", -- or "cmdline" for classic bottom
                format = {
                    cmdline = { icon = ">" },
                    search_down = { icon = " ⌄" },  -- Nerd Font search icon
                    search_up = { icon = " ⌃" },    -- Nerd Font search icon
                    filter = { icon = "$" },
                    lua = { icon = " " },           -- Nerd Font lua icon
                    help = { icon = "󰋖" },           -- Nerd Font help icon
                },
            },

            -- Message routing for cleaner experience
            routes = {
                {
                    filter = { event = "msg_show", kind = "", find = "written" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", find = "%d+L, %d+B" },
                    opts = { skip = true },
                },
                -- Route LSP progress to mini view
                {
                    filter = { event = "lsp", kind = "progress" },
                    opts = { skip = false },
                },
            },

            -- LSP configuration
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                progress = {
                    enabled = true,
                    view = "mini",
                },
                hover = {
                    enabled = true,
                    silent = false,
                },
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true,
                        luasnip = true,
                        throttle = 50,
                    },
                },
            },

            -- Views configuration
            views = {
                cmdline_popup = {
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    position = {
                        row = "50%",
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = "55%",
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                },
            },

            -- Use snacks backend for notifications (you have snacks installed)
            notify = {
                backend = "snacks",
            },
        },
        keys = {
            {
                "<leader>nh",
                function()
                    require("noice").cmd("history")
                end,
                desc = "[N]oice [H]istory",
            },
            {
                "<leader>nl",
                function()
                    require("noice").cmd("last")
                end,
                desc = "[N]oice [L]ast Message",
            },
            {
                "<leader>ne",
                function()
                    require("noice").cmd("errors")
                end,
                desc = "[N]oice [E]rrors",
            },
            {
                "<c-f>",
                function()
                    if not require("noice.lsp").scroll(4) then
                        return "<c-f>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Forward in LSP Docs",
                mode = { "i", "n", "s" },
            },
            {
                "<c-b>",
                function()
                    if not require("noice.lsp").scroll(-4) then
                        return "<c-b>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Backward in LSP Docs",
                mode = { "i", "n", "s" },
            },
        },
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
            vim.g.gruvbox_material_disable_italic_comment = 0
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_cursor = "auto"
            --  0 no transparency, 1 background and bars, 2 full transparency
            --  needs to be set to 0 to support light/dark switching
            vim.g.gruvbox_material_transparent_background = 1
            vim.g.gruvbox_material_dim_inactive_windows = 1
            vim.g.gruvbox_material_visual = "grey background"
            vim.g.gruvbox_material_sign_column_background = "none"
            vim.g.gruvbox_material_spell_foreground = "none"
            vim.g.gruvbox_material_spell_background = "blue"
            vim.g.gruvbox_material_ui_contrast = "low"
            vim.g.gruvbox_material_show_eob = 1
            vim.g.gruvbox_material_float_style = "bright"
            vim.g.gruvbox_material_diagnostic_text_highlight = 1
            vim.g.gruvbox_material_diagnostic_line_highlight = 0
            vim.g.gruvbox_material_diagnostic_virtual_text = "gray"
            vim.g.gruvbox_material_disable_terminal_colors = 1
            vim.g.gruvbox_material_statusline_style = "default"
            vim.g.gruvbox_material_lightline_disable_bold = 0
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
            fallback = "light",
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

    -- collection of various small plugins/modules slowly ingested
    -- by core neovim currently using:
    -- * mini.surround as a replacement for vim-surround
    -- * mini.ai extends motions
    -- * mini.indentscope visualizes indent scope
    -- * mini.trailspace trims trailing whitespaces on save
    -- * mini.bracketed for enhanced navigation with bracket mappings
    -- * mini.bufremove for smart buffer deletion
    -- * mini.move for moving lines/blocks
    -- * mini.splitjoin for splitting/joining code structures
    {
        "nvim-mini/mini.nvim",
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
            -- provides better UX than snacks.indent (animated + navigation)
            -- - [i    - goto top of indent
            -- - ]i    - goto bottom of indent
            require("mini.indentscope").setup({
                draw = {
                    delay = 50, -- delay before showing scope
                    animation = require("mini.indentscope").gen_animation.quadratic({
                        easing = "out",
                        duration = 20,
                        unit = "total",
                    }),
                },
                symbol = "│", -- character for scope line
                options = {
                    try_as_border = true, -- try to use border for scope
                },
            })

            -- trailing whitespace handling (replaces vim-better-whitespace)
            require("mini.trailspace").setup()

            -- Auto-trim on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function()
                    local save = vim.fn.winsaveview()
                    MiniTrailspace.trim()
                    MiniTrailspace.trim_last_lines()
                    vim.fn.winrestview(save)
                end,
            })

            -- code commenting with treesitter awareness (replaces Comment.nvim)
            require("mini.comment").setup({
                options = {
                    ignore_blank_line = false,
                    start_of_line = false,
                    pad_comment_parts = true,
                },
                mappings = {
                    comment = "gc",
                    comment_line = "gcc",
                    comment_visual = "gc",
                    textobject = "gc",
                },
            })

            -- auto-pairing brackets, quotes, etc (replaces nvim-autopairs)
            require("mini.pairs").setup({
                modes = { insert = true, command = false, terminal = false },
                skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
                skip_ts = { "string" },
                skip_unbalanced = true,
                markdown = true,
            })

            -- enhanced navigation with bracket mappings
            -- - [b / ]b - buffers
            -- - [d / ]d - diagnostic
            -- - [c / ]c - comment
            -- - [f / ]f - file on disk
            -- - [q / ]q - quickfix
            -- - [t / ]t - treesitter node
            require("mini.bracketed").setup()

            -- smart buffer deletion without breaking window layout
            require("mini.bufremove").setup()

            -- move lines and blocks with Alt+hjkl
            -- - Alt+h - move left
            -- - Alt+j - move down
            -- - Alt+k - move up
            -- - Alt+l - move right
            require("mini.move").setup()

            -- split/join code structures (args, arrays, etc)
            -- - gS - toggle split/join
            require("mini.splitjoin").setup()
        end,
    },

    -- detect tabstop and shiftwidth automatically based on file and project
    {
        "tpope/vim-sleuth",
    },

    -- Fuzzy finder (extracted to lua/plugins/telescope.lua)
    { import = "plugins.telescope" },

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


    -- markdown viewing in terminal
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
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

    -- lazygit integration
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            {
                "<leader>gg",
                "<cmd>LazyGit<cr>",
                desc = "LazyGit",
            },
        },
    },

    -- vscode alike diff with merge conflict support
    {
        "esmuellert/codediff.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        cmd = "CodeDiff",
        config = function()
            require("codediff").setup({
                -- Highlight configuration
                highlights = {
                    -- Line-level: accepts highlight group names or hex colors (e.g., "#2ea043")
                    line_insert = "DiffAdd", -- Line-level insertions
                    line_delete = "DiffDelete", -- Line-level deletions

                    -- Character-level: accepts highlight group names or hex colors
                    -- If specified, these override char_brightness calculation
                    char_insert = nil, -- Character-level insertions (nil = auto-derive)
                    char_delete = nil, -- Character-level deletions (nil = auto-derive)

                    -- Brightness multiplier (only used when char_insert/char_delete are nil)
                    -- nil = auto-detect based on background (1.4 for dark, 0.92 for light)
                    char_brightness = nil, -- Auto-adjust based on your colorscheme

                    -- Conflict sign highlights for merge conflict views
                    conflict_sign = nil, -- Unresolved (auto-detect)
                    conflict_sign_resolved = nil, -- Resolved (auto-detect)
                    conflict_sign_accepted = nil, -- Accepted (auto-detect)
                    conflict_sign_rejected = nil, -- Rejected (auto-detect)
                },

                -- Diff view behavior
                diff = {
                    disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
                    max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
                    hide_merge_artifacts = false, -- Hide merge tool temp files (*.orig, *.BACKUP.*, etc)
                },

                -- Explorer panel configuration
                explorer = {
                    position = "left", -- "left" or "bottom"
                    width = 40, -- Width when position is "left"
                    height = 15, -- Height when position is "bottom"
                    indent_markers = true, -- Show indent markers in tree view
                    icons = {
                        folder_closed = "", -- Nerd Font folder icon
                        folder_open = "", -- Nerd Font folder-open icon
                    },
                    view_mode = "list", -- "list" or "tree"
                    file_filter = {
                        ignore = {}, -- Glob patterns to hide
                    },
                },

                -- Keymaps in diff view
                keymaps = {
                    view = {
                        quit = "q", -- Close diff tab
                        toggle_explorer = "<leader>b", -- Toggle explorer visibility (explorer mode only)
                        next_hunk = "]c", -- Jump to next change
                        prev_hunk = "[c", -- Jump to previous change
                        next_file = "]f", -- Next file in explorer mode
                        prev_file = "[f", -- Previous file in explorer mode
                        diff_get = "do", -- Get change from other buffer (like vimdiff)
                        diff_put = "dp", -- Put change to other buffer (like vimdiff)
                    },
                    explorer = {
                        select = "<CR>", -- Open diff for selected file
                        hover = "K", -- Show file diff preview
                        refresh = "R", -- Refresh git status
                        toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
                    },
                    conflict = {
                        accept_incoming = "<leader>ct", -- Accept incoming (theirs/left) change
                        accept_current = "<leader>co", -- Accept current (ours/right) change
                        accept_both = "<leader>cb", -- Accept both changes (incoming first)
                        discard = "<leader>cx", -- Discard both, keep base
                        next_conflict = "]x", -- Jump to next conflict
                        prev_conflict = "[x", -- Jump to previous conflict
                        diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
                        diffget_current = "3do", -- Get hunk from current (right/ours) buffer
                    },
                },
            })
        end,
        keys = {
            -- Open diff explorer showing git status
            {
                "<leader>vd",
                "<cmd>CodeDiff<cr>",
                desc = "[V]scode [D]iff Explorer",
            },
            -- Compare current file with HEAD
            {
                "<leader>vf",
                "<cmd>CodeDiff file HEAD<cr>",
                desc = "[V]scode Diff [F]ile vs HEAD",
            },
            -- Compare current file with previous commit
            {
                "<leader>vp",
                "<cmd>CodeDiff file HEAD~1<cr>",
                desc = "[V]scode Diff File vs [P]revious",
            },
            -- Compare with specific branch (will prompt for branch name)
            {
                "<leader>vb",
                function()
                    local branch = vim.fn.input("Branch name: ")
                    if branch ~= "" then
                        vim.cmd("CodeDiff file " .. branch)
                    end
                end,
                desc = "[V]scode Diff File vs [B]ranch",
            },
            -- Compare with specific revision (will prompt for revision)
            {
                "<leader>vr",
                function()
                    local rev = vim.fn.input("Revision (commit/tag): ")
                    if rev ~= "" then
                        vim.cmd("CodeDiff file " .. rev)
                    end
                end,
                desc = "[V]scode Diff File vs [R]evision",
            },
            -- Compare two arbitrary files
            {
                "<leader>vc",
                function()
                    local file1 = vim.fn.input("First file: ", "", "file")
                    if file1 ~= "" then
                        local file2 = vim.fn.input("Second file: ", "", "file")
                        if file2 ~= "" then
                            vim.cmd("CodeDiff file " .. file1 .. " " .. file2)
                        end
                    end
                end,
                desc = "[V]scode Diff [C]ompare Two Files",
            },
        },
    },

    -- -----------------
    -- Coding assistance
    -- -----------------

    -- LSP configuration (extracted to lua/plugins/lsp/)
    { import = "plugins.lsp" },

    -- Autocompletion (extracted to lua/plugins/completion.lua)
    { import = "plugins.completion" },


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
                        -- enable copilot's native inline suggestions (ghosttext)
                        -- this works alongside sidekick NES: NES provides multi-line refactorings,
                        -- while suggestions provide real-time as-you-type completions
                        suggestion = {
                            enabled = true,
                            auto_trigger = true,
                            debounce = 75,
                            keymap = {
                                accept = "<M-l>",
                                next = "<M-]>",
                                prev = "<M-[>",
                                dismiss = "<C-]>",
                            },
                        },
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
                    -- Core utilities
                    bigfile = { enabled = true },
                    explorer = { enabled = true },     -- Primary file browser (actively used)
                    input = { enabled = true },
                    quickfile = { enabled = true },
                    scope = { enabled = true },
                    statuscolumn = { enabled = true },
                    words = { enabled = true },

                    -- Visual enhancements
                    indent = { enabled = false },      -- Disabled: redundant with mini.indentscope
                    scroll = { enabled = true },       -- Smooth scrolling (actively used)

                    -- Disabled - redundant with other plugins
                    dashboard = { enabled = false },   -- Unused, no startup screen needed
                    picker = { enabled = false },      -- Redundant with Telescope
                    notifier = { enabled = false },    -- Noice uses snacks backend
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
        build = ":TSUpdate",
        lazy = false,
        priority = 100,
        dependencies = {
            -- treesitter autotags
            {
                "windwp/nvim-ts-autotag",
                event = "InsertEnter",
                opts = { enable = true },
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
        config = function()
            -- Enable treesitter-based folding
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt.foldlevelstart = 99

            -- Configure treesitter (using new API)
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash", "css", "dockerfile", "gitignore", "git_config",
                    "gitcommit", "git_rebase", "gitattributes", "go", "gomod",
                    "gosum", "gowork", "helm", "html", "regex", "javascript",
                    "json", "lua", "luadoc", "markdown", "markdown_inline",
                    "python", "terraform", "hcl", "toml", "tsx", "typescript",
                    "vim", "vimdoc", "yaml",
                },
                highlight = { enable = true },
                indent = { enable = true },
                auto_tag = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                },
            })

            -- Auto-open all folds when opening a file
            vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
                pattern = "*",
                callback = function()
                    vim.cmd("normal zR")
                end,
                desc = "Open all folds on file load",
            })
        end,
    },

    -- vim-terraform: Terraform filetype detection and syntax
    {
        "hashivim/vim-terraform",
        ft = { "terraform", "hcl" },
        init = function()
            -- Override default filetype detection (runs before plugin loads)
            vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])

            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { ".terraformrc", "terraform.rc" },
                callback = function()
                    vim.bo.filetype = "hcl"
                end,
                desc = "Set HCL filetype for terraform config files",
            })

            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { "*.hcl", "*.tf", "*.tfvars" },
                callback = function()
                    vim.bo.filetype = "terraform"
                end,
                desc = "Set Terraform filetype",
            })

            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { "*.tfstate", "*.tfstate.backup" },
                callback = function()
                    vim.bo.filetype = "json"
                end,
                desc = "Set JSON filetype for Terraform state files",
            })
        end,
    },

    -- conform.nvim: code formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>fm",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "[F]or[m]at buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                lua = { "stylua" },
                python = { "ruff_format" },
                go = { "goimports" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                terraform = { "terraform_fmt" },
            },
            format_on_save = {
                timeout_ms = 3000,
                lsp_fallback = true,
            },
        },
    },

    -- nvim-lint: linting and diagnostics
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile", "BufWritePost" },
        config = function()
            local lint = require("lint")

            -- configure linters per filetype
            lint.linters_by_ft = {
                markdown = { "vale" },
                text = { "vale" },
            }

            -- create autocmd for linting
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
                group = lint_augroup,
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
}
