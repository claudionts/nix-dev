_: {
  home.file.".local/share/icons/teams.png".source = ./icons/teams.png;

  home.file.".local/share/applications/teams.desktop".text = ''
    [Desktop Entry]
    Name=Microsoft Teams
    Exec=env ELECTRON_DISABLE_SANDBOX=1 teams-for-linux
    Icon=$HOME/.local/share/icons/teams.png
    Type=Application
    Categories=Network;InstantMessaging;
    StartupNotify=true
  '';

  # Configurações de ambiente específicas do asdf (sem PATH)
  home.sessionVariables = {
    ASDF_DIR = "$HOME/.asdf";
    ASDF_DATA_DIR = "$HOME/.asdf";
  };
}
