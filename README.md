# Nix Development Environment

Personal development environment configuration using Nix Flakes and Home Manager.

[![CI](https://github.com/claudionts/nix-dev/actions/workflows/ci.yml/badge.svg)](https://github.com/claudionts/nix-dev/actions/workflows/ci.yml)

## 🚀 Quick Installation

```bash
# Clone the repository
git clone https://github.com/claudionts/nix-dev.git ~/.config/nix-dev

# Navigate to the directory
cd ~/.config/nix-dev

# Apply the configuration
nix run nixpkgs#home-manager -- switch --flake ~/.config/nix-dev --impure

# Or use the helper script
./dev.sh apply
```

## 📦 What's Included

- **Shell**: Fish with Starship prompt
- **Tools**: bat, eza, fzf, ripgrep, lazygit, etc.
- **Development**: 
  - Go + gopls
  - Erlang + Elixir + elixir-ls
  - ASDF for language version management
  - Ruby, Lua, autotools
- **Editor**: Neovim
- **Terminal**: tmux configured
- **Git**: optimized configurations

## 🛠️ Development Script

The `dev.sh` script provides useful commands for development:

```bash
./dev.sh check    # Check flake and syntax
./dev.sh build    # Build the configuration
./dev.sh apply    # Apply the configuration
./dev.sh format   # Format Nix code
./dev.sh update   # Update dependencies
./dev.sh clean    # Clean Nix cache
./dev.sh test     # Run all tests
./dev.sh ci       # Simulate CI environment
```

## 🔄 Continuous Integration

The project uses GitHub Actions for:

- ✅ Check flake validity
- 🏗️ Test configuration build
- 🎨 Check code formatting
- 🧪 Test on multiple NixOS versions
- 📦 Automatically update dependencies (Renovate)

## 📂 Project Structure

```
.
├── flake.nix              # Main flake configuration
├── home-manager.nix       # Imports and global configurations
├── home.nix              # User-specific files
├── programs/             # Configurations per tool
│   ├── fish.nix          # Fish shell
│   ├── git.nix           # Git
│   ├── tmux.nix          # Terminal multiplexer
│   └── packages.nix      # Package list
├── .github/              # CI/CD
│   └── workflows/
│       └── ci.yml        # GitHub Actions
└── dev.sh               # Development helper script
```

## 🔧 Customization

1. **Add new packages**: Edit `programs/packages.nix`
2. **Configure tools**: Add files in `programs/`
3. **Modify user**: Adjust `flake.nix` and `home-manager.nix`

## 🐛 Troubleshooting

```bash
# Check flake issues
nix flake check --show-trace

# Clean cache in case of problems
nix-collect-garbage -d

# Check detailed logs
./dev.sh ci
```

## 📋 Useful Commands

```bash
# Update only a specific input
nix flake lock --update-input nixpkgs

# See what changed
nix store diff-closures /nix/var/nix/profiles/per-user/$USER/home-manager*

# Rollback to previous generation
home-manager generations
home-manager switch --switch-generation <ID>
```
