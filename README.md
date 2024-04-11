# NeoVim Dotfiles

Welcome to my personal NeoVim dotfiles repository, specifically tailored for infrastructure development. This configuration is designed for NeoVim 0.10, enhancing the development experience by streamlining workflows and incorporating productivity-boosting features tailored to infrastructure as code (IaC). While optimized for NeoVim 0.10, experience with other versions may vary. Built with `lazy.nvim` and `mason` for efficient plugin management, it aims to provide a powerful, flexible, and visually pleasing coding environment.

![Screenshot](./docs/screenshot.png)

## Features

- **Effortless Plugin Management:** Powered by `lazy.nvim` and [Mason](https://github.com/williamboman/mason.nvim), enabling automatic installation and updates of plugins, formatters and LSPs.
- **Custom Keybindings:** Intuitive shortcuts to improve navigation and editing efficiency, discoverable with [whichkey](https://github.com/folke/which-key.nvim).
- **Enhanced Language Support:** Default support for Terraform and Golang, essential for infrastructure development, along with YAML and JSON validation tools to ensure configuration integrity.
- **Gruvbox Theme:** Utilizes the popular [gruvbox theme](https://github.com/morhetz/gruvbox) for a warm, eye-friendly color scheme that's easy on the eyes during long coding sessions.
- **Minimalist Aesthetic:** A clean and minimalist interface with no status line, using [noice](https://github.com/folke/noice.nvim) and [telescope](https://github.com/nvim-telescope/telescope.nvim) for user interface, focusing on maximizing screen real estate and reducing distractions.
- **Performance Optimized:** A fast and responsive configuration, ensuring minimal startup time and smooth operation.

## Installation

1. **Backup Your Current Configuration** (Optional): To safeguard your existing setup, consider backing it up before proceeding.

    ```bash
    mv ~/.config/nvim ~/.config/nvim.backup
    ```

2. **Clone the Repository**: Get the configuration by cloning this repository into your `.config/nvim` directory.

    ```bash
    git clone https://github.com/taihen/neovim-dotfiles.git ~/.config/nvim
    ```

3. **Initial Setup with LazyNvim**: On launching NeoVim, `lazy.nvim` will install specified plugins. No additional installation steps are required. Treesitter language definitions, formatters, linters will be installed dynamically.

## External dependencies

Utilities installed with `lazy.vim` and `mason` also have dependencies, which
have to be managed outside of the NeoVim configuration. 

In particular:
- Node.js and npm: For JavaScript/TypeScript plugins and tools.
- Python3: Required by several Python-related plugins.
- Rust and Cargo: For Rust development and Rust-based plugins.
- GoLang: For Go development and Go-based plugins.

## Customization

Feel free to modify and customize the configuration to suit your preferences. The `init.lua` file is the starting point, but most of the configuration is in `./lua/` where you can change key mappings, themes, and plugins.

## Contributing

Contributions are welcome! If you have improvements or corrections, please fork the repository, commit your changes, and submit a pull request.

## License

This NeoVim configuration is released under the [MIT license].
