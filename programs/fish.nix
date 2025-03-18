{ pkgs, ... }: {
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
      alias teams-for-linux="ELECTRON_DISABLE_SANDBOX=1 teams-for-linux"
    '';
  };
}
