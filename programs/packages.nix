{ pkgs, ... }: {
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
    docker
    tmux
    xclip
    gcc
    neovim
    asdf-vm
    gopls
    go
    elixir-ls
  ];
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
}
