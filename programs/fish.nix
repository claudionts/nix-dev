{pkgs, ...}: {
  programs = {
    fish = {
      enable = true;

      # Fish como shell padrão (Home Manager cuida disso)
      # Não precisa de chsh manual

      # shellInit: roda em todo Fish (incl. fish -c e terminais GUI como Ghostty),
      # para asdf e shims estarem no PATH fora só do modo interativo.
      shellInit = ''
        set -q ASDF_DATA_DIR; or set -gx ASDF_DATA_DIR $HOME/.asdf
        if test -f ${pkgs.asdf-vm}/share/asdf-vm/asdf.fish
          set -gx ASDF_DIR ${pkgs.asdf-vm}/share/asdf-vm
          source ${pkgs.asdf-vm}/share/asdf-vm/asdf.fish
        else if test -f $HOME/.asdf/asdf.fish
          set -gx ASDF_DIR $HOME/.asdf
          source $HOME/.asdf/asdf.fish
        end
      '';

      interactiveShellInit = ''
        # Remove greeting padrão
        set -U fish_greeting ""
        set -U EDITOR nvim

        # Adicionar Docker ao PATH (instalado via Homebrew)
        set -gx PATH /opt/homebrew/opt/docker/bin $PATH

        # Configurações do tema bobthefish
        set -g theme_color_scheme dracula
        set -g theme_display_git yes
        set -g theme_display_git_dirty yes
        set -g theme_display_git_untracked yes
        set -g theme_display_git_ahead_verbose yes
        set -g theme_display_git_dirty_verbose yes
        set -g theme_display_git_stashed_verbose yes
        set -g theme_display_git_master_branch yes
        set -g theme_git_worktree_support yes
        set -g theme_use_abbreviated_branch_name no
        set -g theme_display_vagrant yes
        set -g theme_display_docker_machine no
        set -g theme_display_k8s_context yes
        set -g theme_display_hg yes
        set -g theme_display_virtualenv no
        set -g theme_display_nix yes
        set -g theme_display_ruby no
        set -g theme_display_node yes
        set -g theme_display_user ssh
        set -g theme_display_hostname ssh
        set -g theme_display_vi no
        set -g theme_display_date no

        # Configuração bobthefish: DESABILITAR nova linha
        set -g theme_newline_cursor no
        # Configurações extras do bobthefish
        set -g theme_powerline_fonts yes
        set -g theme_nerd_fonts yes
        set -g default_user claudio
      '';

      shellAliases = {
        # Git aliases
        g = "git";
        gc = "git commit";
        gpl = "git pull -p";
        gst = "git status";
        ga = "git add";
        gck = "git checkout";
        gl = "git log";
        gp = "git push";

        # Nix aliases
        hm = "home-manager";
        # Aliases específicos por plataforma
        hmsl = "home-manager switch --flake ~/.config/nix-dev#claudio@linux";
        hmsd = "home-manager switch --flake ~/.config/nix-dev#claudio@darwin";
        # Alias para aplicar configuração via script
        apply-config = "cd ~/.config/nix-dev && ./apply-config.sh";

        # Utility aliases
        ll = "eza -la";
        la = "eza -la";
        ls = "eza";
        cat = "bat";
        grep = "rg";
        find = "fd";
      };

      # Plugins nativos do Fish (sem Fisher)
      plugins = [
        {
          name = "bobthefish";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "theme-bobthefish";
            rev = "e3b4d4eafc23516e35f162686f08a42edf844e40";
            sha256 = "sha256-cXOYvdn74H4rkMWSC7G6bT4wa9d3/3vRnKed2ixRnuA=";
          };
        }
        {
          name = "fzf-fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
            sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
          };
        }
      ];

      functions = {
        # Função para home-manager switch automático
        hms = ''
          if test (uname) = "Darwin"
              home-manager switch --flake ~/.config/nix-dev#claudio@darwin
          else
              home-manager switch --flake ~/.config/nix-dev#claudio@linux
          end
        '';

        # Função para atualizar sistema
        update-system = ''
          if test (uname) = "Darwin"
              echo "🍎 Atualizando macOS..."
              darwin-rebuild switch --flake ~/.config/nix-dev#claudio
              home-manager switch --flake ~/.config/nix-dev#claudio@darwin
          else
              echo "🐧 Atualizando Linux..."
              home-manager switch --flake ~/.config/nix-dev#claudio@linux
          end
          echo "✅ Sistema atualizado!"
        '';

        # Função para limpar cache
        clean-nix = ''
          echo "🧹 Limpando cache do Nix..."
          nix-collect-garbage -d
          nix-store --optimise
          echo "✅ Cache limpo!"
        '';

        # Função para configurar fish como shell padrão no macOS
        setup-fish-shell = ''
          if test (uname) = "Darwin"
              set fish_path (which fish)
              echo "🐟 Configurando Fish como shell padrão no macOS..."

              # Verificar se fish está nos shells válidos
              if not grep -q "$fish_path" /etc/shells
                  echo "📝 Adicionando fish aos shells válidos..."
                  echo "$fish_path" | sudo tee -a /etc/shells
              end

              # Verificar shell atual
              set current_shell (/usr/bin/dscl . -read /Users/(whoami) UserShell | cut -d' ' -f2)
              if test "$current_shell" != "$fish_path"
                  echo "🔄 Configurando fish como shell padrão..."
                  sudo /usr/bin/dscl . -create /Users/(whoami) UserShell "$fish_path"
                  echo "✅ Fish configurado! Reinicie o terminal."
              else
                  echo "✅ Fish já é o shell padrão!"
              end
          else
              echo "🐧 Esta função é apenas para macOS"
          end
        '';
      };
    };

    # Starship prompt (alternativa ao bobthefish se preferir)
    starship = {
      enable = false; # Desabilitado porque estamos usando bobthefish
      enableFishIntegration = false;
    };
  };
}
