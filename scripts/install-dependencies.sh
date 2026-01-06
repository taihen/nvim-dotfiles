#!/bin/bash
# Neovim Dependencies Installation Script
# Installs Neovim and all required dependencies using Homebrew
# Generated: 2026-01-05

set -e  # Exit on error

echo "🚀 Installing Neovim and dependencies..."
echo ""

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}⚠️  Homebrew not found. Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}✓ Homebrew found${NC}"
fi

echo ""
echo -e "${BLUE}📦 Installing core dependencies...${NC}"

# Core tools
brew install neovim
brew install git
brew install make
brew install gcc  # Required for some Neovim plugins

echo ""
echo -e "${BLUE}🔍 Installing search and file tools...${NC}"

# Search and file navigation tools (used by Telescope)
brew install fd
brew install ripgrep
brew install fzf

echo ""
echo -e "${BLUE}📝 Installing language servers...${NC}"

# Language servers (LSP)
brew install bash-language-server      # bashls
brew install gopls                      # Go
brew install terraform-ls               # Terraform
brew install lua-language-server        # Lua
brew install yaml-language-server       # YAML
brew install ansible-language-server    # Ansible
brew install dockerfile-language-server # Docker
brew install helm-ls                    # Helm
brew install marksman                   # Markdown

# Note: jsonls is installed via npm below

echo ""
echo -e "${BLUE}🎨 Installing formatters and linters...${NC}"

# Python formatters
brew install black
brew install isort

# Lua formatter
brew install stylua

# JavaScript/TypeScript formatter
brew install prettier

# Go formatters
brew install gofumpt
brew install goimports-reviser
brew install golines

# Infrastructure tools
brew install tflint      # Terraform linter
brew install trivy       # Security scanner
brew install vale        # Prose linter
brew install yamlfmt     # YAML formatter
brew install yq          # YAML processor
brew install taplo       # TOML formatter

# EditorConfig
brew install editorconfig-checker

echo ""
echo -e "${BLUE}🔧 Installing Git tools...${NC}"

brew install gh          # GitHub CLI
brew install lazygit     # Terminal UI for git

echo ""
echo -e "${BLUE}💾 Installing database tools...${NC}"

brew install sqlite      # Required for neoclip clipboard history

echo ""
echo -e "${BLUE}🔤 Installing Nerd Fonts...${NC}"

# Install Nerd Fonts (choose one or install multiple)
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-fira-code-nerd-font

echo ""
echo -e "${BLUE}📦 Installing Node.js and npm packages...${NC}"

# Node.js (required for some LSP servers and tools)
if ! command -v node &> /dev/null; then
    brew install node
else
    echo -e "${GREEN}✓ Node.js already installed${NC}"
fi

# Install npm-based language servers
npm install -g vscode-langservers-extracted  # Includes jsonls, cssls, htmlls
npm install -g @ansible/ansible-language-server  # Ansible LSP

echo ""
echo -e "${BLUE}🐍 Installing Python packages...${NC}"

# Python (required for some formatters)
if ! command -v python3 &> /dev/null; then
    brew install python3
else
    echo -e "${GREEN}✓ Python 3 already installed${NC}"
fi

# Install Python formatters via pip
pip3 install --upgrade black isort

echo ""
echo -e "${BLUE}🏗️  Installing Go (if not present)...${NC}"

# Go (required for Go LSP and tools)
if ! command -v go &> /dev/null; then
    brew install go
    echo -e "${YELLOW}⚠️  Go installed. You may need to set GOPATH in your shell config${NC}"
else
    echo -e "${GREEN}✓ Go already installed${NC}"
fi

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo "📋 Summary of installed components:"
echo "  - Neovim $(nvim --version | head -1)"
echo "  - fd, ripgrep, fzf (search tools)"
echo "  - 9 language servers (bash, go, terraform, lua, yaml, ansible, docker, helm, markdown)"
echo "  - 15+ formatters and linters"
echo "  - Git, GitHub CLI, LazyGit"
echo "  - SQLite (for clipboard history)"
echo "  - Nerd Fonts (Hack, JetBrains Mono, Fira Code)"
echo ""
echo "🎯 Next steps:"
echo "  1. Set your terminal font to a Nerd Font (e.g., 'Hack Nerd Font')"
echo "  2. Open Neovim: nvim"
echo "  3. Install plugins: :Lazy sync"
echo "  4. Check health: :checkhealth"
echo "  5. Install LSP servers: :Mason"
echo ""
echo "💡 Optional: Update your ~/.zshrc or ~/.bashrc with:"
echo "   export GOPATH=\$HOME/go"
echo "   export PATH=\$PATH:\$GOPATH/bin"
echo ""
