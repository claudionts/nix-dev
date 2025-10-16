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

  # Ativação automática do Fish como shell padrão no macOS
  home.activation.setupDefaultShell = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      fishPath="${pkgs.fish}/bin/fish"
      
      # Verificar se fish está nos shells válidos
      if ! grep -Fxq "$fishPath" /etc/shells 2>/dev/null; then
        $DRY_RUN_CMD echo "Adicionando fish aos shells válidos..."
        $DRY_RUN_CMD echo "$fishPath" | ${pkgs.coreutils}/bin/tee -a /etc/shells > /dev/null
      fi
      
      # Verificar shell atual do usuário usando cut em vez de awk
      currentShell=$(/usr/bin/dscl . -read /Users/$USER UserShell 2>/dev/null | ${pkgs.coreutils}/bin/cut -d' ' -f2 || echo "")
      if [[ "$currentShell" != "$fishPath" ]]; then
        $DRY_RUN_CMD echo "Configurando fish como shell padrão..."
        $DRY_RUN_CMD /usr/bin/dscl . -create /Users/$USER UserShell "$fishPath"
        echo "✅ Fish configurado como shell padrão! Reinicie o terminal."
      else
        echo "✅ Fish já é o shell padrão."
      fi
    ''
  );
}
