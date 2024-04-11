return {
  -- -------
  -- visuals
  -- -------

  -- gruvbox theme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
  },

  -- tints non-active panes
  -- (NOTE: should consider whatever this is worth it)
  {
    "levouh/tint.nvim",
  },

  -- highlight todo, notes, etc in comments
  -- depends at best on plenary, but adding devicons and trouble for
  -- integrations
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

  -- as there is no status line, while working in multiple panes/buffers is
  -- usefull to provide current buffer name, with some workspace diagnostics
  {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup()
    end,
    event = "VeryLazy",
    dependencies = {
      -- optional for icons
      "nvim-tree/nvim-web-devicons",
      -- optional for decorations
      "lewis6991/gitsigns.nvim",
    },
  },

  -- directional indication of cursor jumps
  {
    "gen740/SmoothCursor.nvim",
  },

  -- general colorizer without external deps
  {
    "NvChad/nvim-colorizer.lua",
  },

  -- extended core experience
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- notification handling
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
              require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "Dismiss All Notifications",
          },
        },
        opts = {
          stages = "static",
          timeout = 3000,
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

  -- -----------
  -- handy tools
  -- -----------

  -- collection of various small independent plugins/modules
  -- currently using:
  -- * mini.surround as a replacement for vim-surround
  -- * mini.ai extends motions
  {
    "echasnovski/mini.nvim",
  },

  -- strip whitespaces, that's probably an overkill but still does the work
  -- (TODO: probably can be replaced with mini.trailspace)
  {
    "ntpeters/vim-better-whitespace",
  },

  -- autoclosing pairs
  -- (TODO: probably can be replaced with mini.pairs)
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

  -- git helpers
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- code commenting for multiple formats, successor to vim-commenter with
  -- treesitter integration
  -- (NOTE: probably can be replaced with mini.comment
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
    lazy = false,
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
    },
  },

  -- chatgpt
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  -- popup with possible key bindings of the command you started typing
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  -- indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- glow markdown viewer
  {
    "ellisonleao/glow.nvim",
  },

  -- diagnostics helper
  {
    "folke/trouble.nvim",
    branch = "dev",
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
    opts = {}, -- for default options, refer to the configuration section for custom setup.
  },

  -- -----------------
  -- Coding assistance
  -- -----------------

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
        dependencies = {
          { "hrsh7th/cmp-buffer" },
          { "hrsh7th/cmp-path" },
          { "hrsh7th/cmp-nvim-lsp" },
          { "hrsh7th/cmp-nvim-lua" },
          { "hrsh7th/cmp-emoji" },

          -- snippets
          { "saadparwaiz1/cmp_luasnip" },
          {
            "L3MON4D3/LuaSnip",
            build = (function()
              -- Build Step is needed for regex support in snippets.
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

          -- LSP ncmp icons
          { "onsails/lspkind.nvim" },

          -- SchemaStore support
          { "b0o/schemastore.nvim" },
        },
      },
    },
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

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

  -- restarting LSP servers based on window focus, keeping neovim fast
  {
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },

  -- formatting mostly, drop-in replacement for null-ls
  -- (TODO: should check out duo 'stevearc/conform.nvim' and 'nvim-lint')
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
