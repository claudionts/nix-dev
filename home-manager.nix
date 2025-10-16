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

  # Ativação para configurar fish como shell padrão
  home.activation.setupFishShell = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Verificar se fish está nos shells válidos
      FISH_PATH="${pkgs.fish}/bin/fish"
      if ! grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
        echo "Adicionando fish aos shells válidos..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells
      fi
      
      # Verificar shell atual do usuário
      CURRENT_SHELL=$(dscl . -read "/Users/$(whoami)" UserShell | cut -d' ' -f2)
      if [[ "$CURRENT_SHELL" != "$FISH_PATH" ]]; then
        echo "Configurando fish como shell padrão..."
        sudo chsh -s "$FISH_PATH" "$(whoami)"
        echo "Fish configurado! Reinicie o terminal."
      fi
    ''
  );
}
