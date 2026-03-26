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

  home = {
    packages = with pkgs; [
      # CLI no PATH (alias `hm` e comandos documentados)
      home-manager
      # Fontes Nerd Font (sintaxe 24.05)
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "Hack"];})
      # Fontes adicionais
      fira-code
      jetbrains-mono
      noto-fonts
      noto-fonts-emoji
    ];

    sessionVariables = {
      PATH = "/opt/homebrew/opt/docker/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
      SHELL = "${pkgs.fish}/bin/fish";
    };

    # Configurações básicas
    file = {
      # Arquivos de configuração comuns
      ".hushlogin".text = ""; # Remove mensagem de login
    };
  };

  # Fish como shell de login exige root (/etc/shells + dscl). O Home Manager corre
  # como utilizador normal — não tentar aqui (evita "tee: Permission denied").
  # No Fish: setup-fish-shell  (usa sudo quando necessário)
  home.activation.macosFishLoginHint = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      fishPath="${pkgs.fish}/bin/fish"
      currentShell=$(/usr/bin/dscl . -read "/Users/$USER" UserShell 2>/dev/null | ${pkgs.coreutils}/bin/cut -d' ' -f2 || echo "")
      if ! grep -Fxq "$fishPath" /etc/shells 2>/dev/null || [[ "$currentShell" != "$fishPath" ]]; then
        printf '\n%s\n' "Home Manager: Ghostty já pode usar fish via command = ~/.nix-profile/bin/fish."
        printf '%s\n' "Para tornar fish o shell de login do utilizador (opcional), no Fish executa: setup-fish-shell"
        printf '%s\n\n' "(pede sudo para /etc/shells e UserShell.)"
      fi
    ''
  );
}
