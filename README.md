# NeoVim Dotfiles

Welcome to personal NeoVim configuration repository, specifically tailored for
minimalist infrastructure development. Optimized for NeoVim 0.11+, experience
with earlier versions may vary.
Built with `lazy.nvim` and `mason` for efficient plugin management, it aims to
provide a powerful, flexible, and visually pleasing coding environment.

> NOTE: migration to LazyVim isn't completed as I would like and some plugins
> configuration still lingers in `after/plugin`

![Screenshot](./docs/screenshot.png)

## Features

- **Effortless Plugin Management:** Powered by `lazy.nvim` and
  [Mason](https://github.com/williamboman/mason.nvim), enabling automatic
  installation and updates of plugins, formatters and LSPs.
- **Custom Keybindings:** Intuitive shortcuts to improve navigation and editing
  efficiency, discoverable with
  [whichkey](https://github.com/folke/which-key.nvim).
- **Enhanced Language Support:** Comprehensive support for infrastructure
  development with Terraform, GoLang, Ansible, Helm, and Docker Compose. Includes
  YAML and JSON validation with SchemaStore integration, plus support for Python,
  Bash, Lua, TypeScript, and more via Mason-managed LSPs and formatters.
- **Gruvbox Material Theme:** Utilizes
  [gruvbox-material](https://github.com/sainnhe/gruvbox-material) with material
  design palette for a warm, eye-friendly color scheme that's pleasant on the
  eyes during sessions. While using with
  [Ghostty](https://github.com/ghostty-org/ghostty) or
  [Kitty](https://sw.kovidgoyal.net/kitty/) terminals, or any other terminal
  emulator that supports switching between dark and light themes, it also
  switches automatically when the system theme changes.
- **Minimalist Aesthetic:** A clean and minimalist interface with no status
  line, using [noice](https://github.com/folke/noice.nvim) and
  [telescope](https://github.com/nvim-telescope/telescope.nvim) for user
  interface, focusing on maximizing screen real estate and reducing distractions.
- **Performance Optimized:** A fast and responsive configuration, ensuring
  minimal startup time and smooth operation.
- **Enhanced Editing:** Powered by
  [mini.nvim](https://github.com/echasnovski/mini.nvim) suite providing advanced
  text objects, surround operations, indent visualization, and automatic
  whitespace management.
- **Clipboard Manager:** Persistent clipboard history with
  [neoclip](https://github.com/AckslD/nvim-neoclip.lua) integrated into Telescope
  for quick access to previous yanks.
- **Markdown Experience:** Terminal rendering with
  [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
  and browser preview via
  [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim).
- **Schema Validation:** JSON and YAML schema validation powered by
  [SchemaStore](https://github.com/b0o/schemastore.nvim) with support for custom
  schemas (e.g., ArgoCD).
- **AI Enhanced Code Assistance:** Utilizing
  [Copilot](https://github.com/zbirenbaum/copilot.lua) for inline code
  completion and [Sidekick](https://github.com/folke/sidekick.nvim) for agentic
  AI assistance with CLI integration (supporting Claude, Gemini, and other AI
  agents via tmux).

## Notable Plugins

This configuration includes carefully selected plugins organized by category:

### UI & Visual Experience

- [gruvbox-material](https://github.com/sainnhe/gruvbox-material) - Material design Gruvbox variant
- [auto-dark-mode.nvim](https://github.com/f-person/auto-dark-mode.nvim) - Automatic theme switching
- [noice.nvim](https://github.com/folke/noice.nvim) - Enhanced UI for messages and cmdline
- [incline.nvim](https://github.com/b0o/incline.nvim) - Buffer information display (no statusline)
- [dressing.nvim](https://github.com/stevearc/dressing.nvim) - Enhanced vim.ui components
- [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua) - Color code highlighting
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - Highlight TODO/NOTE comments
- [vim-illuminate](https://github.com/RRethy/vim-illuminate) - Highlight word under cursor

### AI & Completion

- [sidekick.nvim](https://github.com/folke/sidekick.nvim) - Agentic AI assistance with CLI agents
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot integration
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Autocompletion engine
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine

### LSP & Language Tools

- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP/tool installer
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configurations
- [lsp-timeout.nvim](https://github.com/hinell/lsp-timeout.nvim) - Auto-restart LSP for performance
- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) - Formatting and linting
- [schemastore.nvim](https://github.com/b0o/schemastore.nvim) - JSON/YAML schema validation
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax parsing

### Navigation & Search

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Keybinding discovery
- [trouble.nvim](https://github.com/folke/trouble.nvim) - Diagnostics and quickfix UI
- [nvim-neoclip.lua](https://github.com/AckslD/nvim-neoclip.lua) - Persistent clipboard manager

### Editing Enhancement

- [mini.nvim](https://github.com/echasnovski/mini.nvim) - Collection of independent modules:
  - mini.ai - Advanced text objects
  - mini.surround - Bracket/quote manipulation
  - mini.indentscope - Indent visualization
  - mini.trailspace - Whitespace management
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) - Code commenting
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Auto-closing pairs
- [vim-sleuth](https://github.com/tpope/vim-sleuth) - Auto-detect indentation

### Markdown Support

- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) - Terminal rendering
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) - Browser preview

See `lua/plugins.lua` for complete list and configurations.

## Installation

1. **Backup Your Current Configuration**: To safeguard your existing
   setup, consider backing it up before proceeding.

   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone the Repository**: Get the configuration by cloning this repository
   into your `.config/nvim` directory.

   ```bash
   git clone https://github.com/taihen/neovim-dotfiles.git ~/.config/nvim
   ```

3. **Initial Setup with LazyNvim**: On launching NeoVim, `lazy.nvim`
   installs specified plugins. No additional installation steps required.
   Treesitter language definitions, formatters, linters installs
   dynamically.

## External dependencies

Utilities installed with `lazy.vim` and `mason` also have dependencies, not
managed by NeoVim.

In particular:

- **Build Tools:** A C compiler (like `gcc` or `clang`) is required by `nvim-treesitter` to build language parsers.
- **Node.js and npm:** For JavaScript/TypeScript based plugins and language servers (e.g., `copilot.lua`, `eslint`).
- **Python3 and pip:** Required by several Python-based plugins and tools (e.g., `yamllint`, some MCP servers).
- **Rust and Cargo:** For Rust development and Rust-based plugins/tools (e.g., `ruff`).
- **GoLang:** For Go development and Go-based language servers (`gopls`).
- **Terraform CLI:** Required for Terraform language support and commands.
- **make:** Required by `telescope-fzf-native.nvim` for building the native FZF sorter.
- **sqlite3:** Required by `nvim-neoclip.lua` for persistent clipboard history.
- **tmux:** Required by `sidekick.nvim` for CLI integration and agentic workflows.
- **Search Utilities (Recommended):**
  - `ripgrep`: Highly recommended for fast searching in Telescope.
  - `fd`: Recommended for fast file finding in Telescope.
- **Optional (Depending on Use Case):**
  - `Docker`: May be needed if running certain tools or MCP servers in containers.
  - `shellharden`: Shell script hardening and formatting (used by none-ls).
  - `shfmt`: Shell script formatting (used by none-ls).
  - `vale`: Syntax-aware prose linting (used by none-ls).
  - AI Agents: `claude`, `gemini`, `codex` or `opencode` CLI tools to power `sidekick.nvim`

Ensure these dependencies are installed via your system's package manager (e.g., `apt`, `brew`, `pacman`).

## Customization

Feel free to modify and customize the configuration to suit your preferences.
The `init.lua` file is the starting point, but most of the configuration is in
`./lua/` where you can change key mappings, themes, and plugins.

## Contributing

Contributions are welcome. This is never ending work in progress and never
expect to be perfect. If you have improvements or corrections, please submit a
pull request. Thank you in advance.

## License

This NeoVim configuration, feel free to do whatever. Have fun, copy, and
paste parts of it to your likening.
