# 🚀 Ambiente Nix Automático# 🚀 Ambiente Nix Automático



Configuração completa de desenvolvimento para Linux e macOS com **instalação automática**.Configuração c---



## ⚡ Instalação**Ambiente reproduzível com Nix** ✨ta de desenvolvimento para Linux e macOS com **instalação automática**.



```bash## ⚡ Instalação

git clone https://github.com/claudionts/nix-dev.git ~/.config/nix-dev

cd ~/.config/nix-dev```bash

./apply-config.shgit clone https://github.com/claudionts/nix-dev.git ~/.config/nix-dev

```cd ~/.config/nix-dev

./apply-config.sh

**Pronto!** O script instala tudo: Nix, Home Manager, configurações.```



## 📦 Incluso**Pronto!** O script instala tudo: Nix, Home Manager, configurações.



- **Neovim** com CodeCompanion.nvim + GitHub Copilot## 📦 Incluso

- **Fish Shell** com tema bobthefish

- **Tmux** configurado- **Neovim** com CodeCompanion.nvim + GitHub Copilot

- **Nerd Fonts** automáticas- **Fish Shell** com tema bobthefish

- **Git** + configurações- **Tmux** configurado

- **Nerd Fonts** automáticas

## 🔄 Comandos Úteis- **Git** + configurações

## 🔄 Comandos Úteis

```bash

# Reaplicar configuração```bash

./apply-config.sh# Reaplicar configuração

./apply-config.sh

# Comandos do Fish

update-system  # Atualiza sistema# Comandos do Fish

clean-nix      # Limpa cacheupdate-system  # Atualiza sistema

clean-nix      # Limpa cache

# Manutenção Nix

nix-collect-garbage -d    # Limpar# Manutenção Nix

nix flake update          # Atualizarnix-collect-garbage -d    # Limpar

```nix flake update          # Atualizar

```

## 🛠️ Personalizar

## 🛠️ Personalizar

Edite os arquivos em `programs/` para ajustar:

- `fish.nix` - Shell e temaEdite os arquivos em `programs/` para ajustar:

- `neovim.nix` - Editor e plugins  - `fish.nix` - Shell e tema

- `packages.nix` - Programas instalados- `neovim.nix` - Editor e plugins  

- `git.nix` - Configurações Git- `packages.nix` - Programas instalados

- `git.nix` - Configurações Git

---

---

**Ambiente reproduzível com Nix** ✨
**Ambiente reproduzível com Nix** ✨

### �️ **Linguagens**
- **Elixir + Erlang** com LSP (elixir-ls)
- **Go** com gopls
- **Node.js + Yarn**
- **Ruby, Lua** 
- **ASDF** para gerenciamento de versões

### 📱 **CLI Tools**
- **bat** (substitui cat)
- **eza** (substitui ls) 
- **fzf** (fuzzy finder)
- **ripgrep** (substitui grep)
- **fd** (substitui find)
- **lazygit** (interface Git)
- **starship** (prompt)

### 🔤 **Fontes Nativas**
- **FiraCode Nerd Font**
- **JetBrains Mono**
- **Noto Fonts + Emoji**

## 🔧 Estrutura do Projeto

```
nix-dev/
├── 📄 flake.nix              # Configuração multi-plataforma
├── 🏠 home-manager.nix       # Base do Home Manager + Fontes  
├── 🏡 home.nix              # Configurações de usuário
├── 🚀 apply-config.sh        # Script simples de aplicação
├── 🛠️ dev.sh                # Script de desenvolvimento
└── 📁 programs/             # Configurações por programa
    ├── 🐟 fish.nix          # Fish nativo + bobthefish
    ├── 📝 git.nix           # Git + aliases
    ├── ✏️  neovim.nix        # Neovim completo
    ├── 📦 packages.nix      # Pacotes por plataforma
    └── 🪟 tmux.nix          # Tmux configurado
```

## 🔄 Comandos Úteis

### 🎨 **Comandos Nativos do Fish**
```bash
update-system  # Atualiza todo o sistema
clean-nix      # Limpa cache do Nix
```

### 📱 **Comandos por Plataforma**
```bash
# Linux
home-manager switch --flake ~/.config/nix-dev#claudio@linux

# macOS  
home-manager switch --flake ~/.config/nix-dev#claudio@darwin

# Ou simplesmente
./apply-config.sh  # Detecta automaticamente a plataforma
```

### 🧹 **Manutenção**
```bash
nix-collect-garbage -d          # Limpar cache
nix-store --optimise           # Otimizar store
nix flake update               # Atualizar inputs
```

## 🛠️ **Script de Desenvolvimento**

O `dev.sh` oferece comandos para desenvolvimento:

```bash
./dev.sh check    # Verificar flake
./dev.sh build    # Construir configuração
./dev.sh apply    # Aplicar configuração
./dev.sh format   # Formatar código Nix
./dev.sh update   # Atualizar dependências
./dev.sh clean    # Limpar cache
./dev.sh test     # Executar testes
./dev.sh ci       # Simular ambiente CI
```

## 🌊 **Configurações Específicas**

### 🍎 **macOS**
- **GNU Coreutils** para compatibilidade
- **Terminal Notifier** para notificações
- **Fontes Nerd Font** otimizadas
- **Pacotes específicos** do macOS

### 🐧 **Linux**
- **XClip** para clipboard no X11
- **Teams for Linux** nativo
- **Headers de desenvolvimento** (libxml2, libxslt, zlib)
- **Configurações específicas** para ambiente Linux

### 🤝 **Ambas Plataformas**
- **Home Manager puro** - sem complexidade extra
- **Fish shell** com tema bobthefish
- **Mesmas ferramentas** e configurações

## 💡 **Por que 100% Nativo?**

### ✅ **Vantagens:**
- **Reproduzível** - Funciona igual em qualquer máquina
- **Declarativo** - Toda configuração em código
- **Rollback** - Desfaz mudanças automaticamente
- **Gestão automática** - Dependências resolvidas pelo Nix
- **Sem scripts** - Tudo gerenciado pelo sistema
- **Multi-plataforma** - Mesmo código, diferentes sistemas

### 🚫 **Sem mais:**
- ❌ Scripts de instalação manuais
- ❌ Comandos `curl | bash`
- ❌ Configurações imperativas
- ❌ Dependências quebradas
- ❌ Estados inconsistentes

## 🆘 **Troubleshooting**

### **Nix não encontrado:**
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### **Flakes não habilitados:**
```bash
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

### **Logs detalhados:**
```bash
./apply-config.sh 2>&1 | tee install.log
```

## 🤝 **Contribuição**

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona feature'`)
4. Push (`git push origin feature/nova-feature`)
5. Abra um Pull Request

---

**🎉 Desenvolvido com ❤️  usando Nix Flakes**

*Configuração 100% nativa - Zero instalações manuais* ✨

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
