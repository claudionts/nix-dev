# Nix Development Environment

Configuração pessoal do ambiente de desenvolvimento usando Nix Flakes e Home Manager.

[![CI](https://github.com/claudionts/nix-dev/actions/workflows/ci.yml/badge.svg)](https://github.com/claudionts/nix-dev/actions/workflows/ci.yml)

## 🚀 Instalação Rápida

```bash
# Clonar o repositório
git clone https://github.com/claudionts/nix-dev.git ~/.config/nix-dev

# Navegar para o diretório
cd ~/.config/nix-dev

# Aplicar a configuração
nix run nixpkgs#home-manager -- switch --flake ~/.config/nix-dev --impure

# Ou usar o script helper
./dev.sh apply
```

## 📦 O que está incluído

- **Shell**: Fish com Starship prompt
- **Ferramentas**: bat, eza, fzf, ripgrep, lazygit, etc.
- **Desenvolvimento**: 
  - Go + gopls
  - Erlang + Elixir + elixir-ls
  - ASDF para gerenciar versões de linguagens
  - Ruby, Lua, autotools
- **Editor**: Neovim
- **Terminal**: tmux configurado
- **Git**: configurações otimizadas

## 🛠️ Script de Desenvolvimento

O script `dev.sh` fornece comandos úteis para desenvolvimento:

```bash
./dev.sh check    # Verifica flake e sintaxe
./dev.sh build    # Builda a configuração
./dev.sh apply    # Aplica a configuração
./dev.sh format   # Formata código Nix
./dev.sh update   # Atualiza dependências
./dev.sh clean    # Limpa cache do Nix
./dev.sh test     # Executa todos os testes
./dev.sh ci       # Simula ambiente de CI
```

## 🔄 Integração Contínua

O projeto usa GitHub Actions para:

- ✅ Verificar validade do flake
- 🏗️ Testar build da configuração
- 🎨 Verificar formatação do código
- 🧪 Testar em múltiplas versões do NixOS
- 📦 Atualizar dependências automaticamente (Renovate)

## 📂 Estrutura do Projeto

```
.
├── flake.nix              # Configuração principal do flake
├── home-manager.nix       # Imports e configurações globais
├── home.nix              # Arquivos específicos do usuário
├── programs/             # Configurações por ferramenta
│   ├── fish.nix          # Shell Fish
│   ├── git.nix           # Git
│   ├── tmux.nix          # Terminal multiplexer
│   └── packages.nix      # Lista de pacotes
├── .github/              # CI/CD
│   └── workflows/
│       └── ci.yml        # GitHub Actions
└── dev.sh               # Script helper de desenvolvimento
```

## 🔧 Personalização

1. **Adicionar novos pacotes**: Edite `programs/packages.nix`
2. **Configurar ferramentas**: Adicione arquivos em `programs/`
3. **Modificar usuário**: Ajuste `flake.nix` e `home-manager.nix`

## 🐛 Solução de Problemas

```bash
# Verificar problemas no flake
nix flake check --show-trace

# Limpar cache em caso de problemas
nix-collect-garbage -d

# Verificar logs detalhados
./dev.sh ci
```

## 📋 Comandos Úteis

```bash
# Atualizar apenas uma entrada específica
nix flake lock --update-input nixpkgs

# Ver o que mudou
nix store diff-closures /nix/var/nix/profiles/per-user/$USER/home-manager*

# Reverter para geração anterior
home-manager generations
home-manager switch --switch-generation <ID>
```
