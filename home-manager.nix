{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/packages.nix
    ./programs/neovim.nix
  ];

  # Fontes instaladas via Home Manager
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fontes Nerd Font (sintaxe 24.05)
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Hack" ]; })
    # Fontes adicionais
    fira-code
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
  ];

  home.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  # Configurações básicas
  home.file = {
    # Arquivos de configuração comuns
    ".hushlogin".text = ""; # Remove mensagem de login
  };


}
