# nix-dev

Configuração [Home Manager](https://github.com/nix-community/home-manager) com Nix Flakes para macOS e Linux (utilizador `claudio`). Ferramentas declarativas: Fish, Neovim, Tmux, Git, pacotes em `programs/packages.nix`, etc.

## Requisitos

- [Nix](https://nixos.org/) com **flakes** e **nix-command** (ex.: `experimental-features = nix-command flakes` em `~/.config/nix/nix.conf` ou `/etc/nix/nix.conf`).

## Clonar

```bash
git clone https://github.com/claudionts/nix-dev.git ~/.config/nix-dev
cd ~/.config/nix-dev
```

Ajusta `flake.nix` e `home-manager.nix` se o teu utilizador ou `homeDirectory` forem outros.

## Aplicar a configuração

**Opção A — script (instala Nix/Home Manager se faltar, depois faz switch):**

```bash
./apply.sh
# equivalente: ./apply-config.sh
```

**Opção B — só Home Manager** (recomendado se o Nix já está OK):

```bash
cd ~/.config/nix-dev
home-manager switch --flake ".#<nome>"
```

Substitui `<nome>` conforme a máquina:

| Sistema        | Nome no flake        |
|----------------|----------------------|
| macOS Apple Silicon | `claudio@darwin`  |
| macOS Intel       | `claudio@darwin-intel` |
| Linux             | `claudio@linux`   |

**Primeira vez sem `home-manager` no PATH** (Fish/bash ainda não o encontram):

```bash
cd ~/.config/nix-dev
nix run github:nix-community/home-manager/release-24.05 -- switch --flake ".#claudio@darwin"
```

(Usa `claudio@darwin-intel` ou `claudio@linux` conforme o caso.)

Depois de um switch bem-sucedido, abre **um terminal novo**. O pacote `home-manager` fica em `~/.nix-profile/bin` e o alias `hm` no Fish funciona.

## Fish e shell de login (macOS)

- O Home Manager **não** altera `/etc/shells` nem `UserShell` sozinho (exige `sudo`).
- Para definir Fish como shell de login: no Fish, `setup-fish-shell`.
- No **Ghostty** (ou outro terminal) podes apontar diretamente para `~/.nix-profile/bin/fish` sem mudar o shell de login do sistema.

## Estrutura

```
nix-dev/
├── flake.nix           # Inputs e homeConfigurations
├── home-manager.nix    # Pacotes base, PATH, fontes
├── home.nix            # Ficheiros e variáveis de sessão
├── apply-config.sh     # Instalação + switch + asdf (plugins/runtimes)
├── apply.sh            # Chama apply-config.sh
├── dev.sh              # format, build, apply, check (desenvolvimento)
└── programs/           # fish, git, neovim, packages, tmux
```

## Personalizar

Edita ficheiros em `programs/` (por exemplo `packages.nix`, `fish.nix`) e volta a correr `home-manager switch` ou `./apply.sh`.

## Manutenção

```bash
nix flake update              # atualizar inputs do flake
nix-collect-garbage -d        # libertar espaço na store
home-manager generations      # listar gerações
```

## Avisos do Nix (substituters / trusted user)

Se aparecerem avisos sobre `trusted-public-keys` ou substituters ignorados, o daemon Nix só aplica isso a utilizadores listados em `trusted-users` em `/etc/nix/nix.conf` (macOS: requer admin). Os avisos não impedem builds normais com a cache pública padrão.

## Desenvolvimento local

```bash
./dev.sh format   # Alejandra
./dev.sh check    # formatação + flake check + build
./dev.sh apply    # switch via nix run nixpkgs#home-manager (ajusta o flake se precisares de outro output)
```
