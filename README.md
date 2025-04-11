# NeoVim Dotfiles

Welcome to personal NeoVim configuration repository, specifically tailored for
minimalist infrastructure development. Optimized for NeoVim 0.10 (although used
currntly with 0.11), experience with other versions may vary.
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
- **Enhanced Language Support:** Default support for Terraform and GoLang,
  essential for infrastructure development, along with YAML and JSON validation
  tools to ensure configuration integrity.
- **Gruvbox Theme:** Utilizes the popular [gruvbox
  theme](https://github.com/morhetz/gruvbox) for a warm, eye-friendly scheme
  that's easy on the eyes during long sessions. While using with
  [Ghostty](https://github.com/ghostty/Ghostty) or
  [Kitty](https://sw.kovidgoyal.net/kitty/) terminals, that support switch
  between dark and light themes, it also switch automatically when the system
  theme changes.
- **Minimalist Aesthetic:** A clean and minimalist interface with no status
  line, using [noice](https://github.com/folke/noice.nvim) and
  [telescope](https://github.com/nvim-telescope/telescope.nvim) for user
  interface, focusing on maximizing screen real estate and reducing distractions.
- **Performance Optimized:** A fast and responsive configuration, ensuring
  minimal startup time and smooth operation.
- **AI Enhanced Code Assistance:** Constantly experimenting with AI assistance,
  this is most likely the more dynamic part of this configuration. Currently
  [Avante](https://github.com/yetone/avante.nvim) as a agent and
  [MCPHub](https://github.com/ravitemer/mcphub.nvim) for extended capabilities.
  Additionally utilizing [Copilot](https://github.com/zbirenbaum/copilot.lua)
  and [Supermaven](https://github.com/supermaven-inc/supermaven-nvim) for code
  completion.
  Avante is configured to use:
  - OpenRouter as the default provider with free model (deepseek-r1)
  - Gemini
  - Claude
  - Ollama
  - Deepseek
  - Perplexity

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
- **Search Utilities (Recommended):**
  - `ripgrep`: Highly recommended for fast searching in Telescope.
  - `fd`: Recommended for fast file finding in Telescope.
- **Optional (Depending on Use Case):**
  - `Docker`: May be needed if running certain tools or MCP servers in containers.
  - `Ollama`: If using local AI models via `avante.nvim`.

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
paste s of it to your likening.
