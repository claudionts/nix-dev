{pkgs, ...}: {
  programs.docker = {
    enable = true;
  };

  # Configurar o serviço systemd para o Docker
  systemd.services.docker = {
    enable = true;
    description = "Docker Daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/dockerd";
      Restart = "always";
      ExecReload = "${pkgs.docker}/bin/docker reload";
    };
  };

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
