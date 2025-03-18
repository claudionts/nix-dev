{pkgs, ...}: {
  home.file.".local/share/icons/teams.png".source = ./icons/teams.png;

  home.file.".local/share/applications/teams.desktop".text = ''
    [Desktop Entry]
    Name=Microsoft Teams
    Exec=teams-for-linux
    Icon=$HOME/.local/share/icons/teams.png
    Type=Application
    Categories=Network;InstantMessaging;
    StartupNotify=true
  '';
}
