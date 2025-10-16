{
  pkgs,
  lib,
  ...
}: {
  programs = {
    fish = {
      enable = true;

      # Fish como shell padrão (Home Manager cuida disso)
      # Não precisa de chsh manual

      interactiveShellInit = ''
        # Remove greeting padrão
        set -U fish_greeting ""
        set -U EDITOR nvim

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
        set -g theme_display_cmd_duration yes
        set -g theme_title_display_process yes
        set -g theme_title_display_path no
        set -g theme_title_display_user yes
        set -g theme_title_use_abbreviated_path no
        set -g theme_date_format "+%a %H:%M"
        set -g theme_avoid_ambiguous_glyphs yes
        set -g theme_powerline_fonts yes
        set -g theme_nerd_fonts yes
        set -g theme_show_exit_status yes
        set -g theme_display_jobs_verbose yes
        set -g default_user claudio
        set -g theme_color_scheme terminal-dark
        set -g fish_prompt_pwd_dir_length 1
        set -g theme_project_dir_length 1
        set -g theme_newline_cursor yes
        set -g theme_newline_prompt '$ '
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
        hms = "home-manager switch --flake ~/.config/nix-dev";
        hmsl = "home-manager switch --flake ~/.config/nix-dev#claudio@linux";
        hmsd = "home-manager switch --flake ~/.config/nix-dev#claudio@darwin";

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
      };
    };

    # Starship prompt (alternativa ao bobthefish se preferir)
    starship = {
      enable = false; # Desabilitado porque estamos usando bobthefish
      enableFishIntegration = false;
    };
  };
}
