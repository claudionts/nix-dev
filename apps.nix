{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      xclip # Para integração com o X11 clipboard
      xsel # Alternativa para copiar e colar
      wl-clipboard # Para Wayland (se estiver usando Wayland)
    ];
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      vim.opt.number = true

      local o = vim.o
      local g = vim.g

      o.clipboard = "unnamedplus"

      o.number = true

      vim.opt.numberwidth = 1

      o.swapfile = false

      g.markdown_fenced_languages = {
          "python", "elixir", "bash", "dockerfile", 'sh=bash'
      }
    '';
  };

  programs.git = {
    enable = true;
    userName = "Claudio Neto";
    userEmail = "claudionts@gmail.com";
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -g focus-events on
      set-option -a terminal-features 'rio:RGB'

      set -g default-command fish
      set -g history-limit 4000
    '';
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
      gc = "git commit";
      gpl = "g pull -p";
      gst = "g status";
      ga = "git add";
      gck = "git checkout";
      gl = "git log";
      gp = "git push";
    };
    interactiveShellInit = ''
      set -gx PATH $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin $PATH

      # Remove a mensagem padrão do Fish
      set -U fish_greeting ""
      set -U EDITOR nvim

      # Verifica se o OMF está instalado, se não, instala
      if not test -d ~/.local/share/omf
        echo "Instalando Oh My Fish..."
        curl -L https://get.oh-my.fish | fish
      end
    '';
  };

  home.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
  };

  # home.file.".config/fish/functions/fisher.fish".text = ''
  #   fisher install jorgebucaran/fisher
  #   fisher install PatrickF1/fzf.fish
  #   fisher install franciscolourenco/done
  # '';

  home.file.".local/share/icons/teams.png".source = ./icons/teams.png;

  home.file.".local/share/applications/teams.desktop".text = ''
    format = '$all$directory$character'
    [Desktop Entry]
    Name=Microsoft Teams
    Exec=teams-for-linux
    Icon=$HOME/.local/share/icons/teams.png
    Type=Application
    Categories=Network;InstantMessaging;
    StartupNotify=true
  '';

  home.packages = with pkgs; [
    fish
    curl
    starship
    bat
    eza
    fzf
    ripgrep
    teams-for-linux
    fd
  ];
}
