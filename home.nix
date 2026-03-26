_: {
  home = {
    file = {
      ".local/share/icons/teams.png".source = ./icons/teams.png;

      ".local/share/applications/teams.desktop".text = ''
        [Desktop Entry]
        Name=Microsoft Teams
        Exec=env ELECTRON_DISABLE_SANDBOX=1 teams-for-linux
        Icon=$HOME/.local/share/icons/teams.png
        Type=Application
        Categories=Network;InstantMessaging;
        StartupNotify=true
      '';
    };

    # Dados/plugins do asdf no home; ASDF_DIR vem do pacote Nix (fish shellInit)
    sessionVariables = {
      ASDF_DATA_DIR = "$HOME/.asdf";
    };
  };
}
