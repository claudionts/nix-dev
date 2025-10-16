{pkgs, lib, ...}: 

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  
  # Pacotes comuns para ambas as plataformas
  commonPackages = with pkgs; [
    fish
    curl
    starship
    bat
    eza
    fzf
    ripgrep
    fd
    tmux
    gcc
    asdf-vm
    gopls
    go
    erlang
    elixir
    elixir-ls
    luajitPackages.luarocks
    lua
    lazygit
    alejandra
    autoconf
    automake
    libevent
    pkg-config
    sqlite
    czmq
    gnumake
    ruby
    nodejs
    yarn
  ];
  
  # Pacotes específicos do Linux
  linuxPackages = with pkgs; [
    xclip           # Clipboard no Linux
    teams-for-linux # Teams específico para Linux
    libxml2.dev     # Headers de desenvolvimento
    libxslt.dev
    zlib.dev
  ];
  
  # Pacotes específicos do macOS
  darwinPackages = with pkgs; [
    # Para macOS, usamos pbcopy/pbpaste (built-in)
    # Adicione pacotes específicos do macOS aqui se necessário
    coreutils       # GNU coreutils para macOS
    findutils       # GNU findutils
    gnu-sed         # GNU sed
    gawk            # GNU awk
    gnutar          # GNU tar
    gzip            # GNU gzip
    watch           # watch command
    terminal-notifier # Notificações no macOS
  ];
  
in {
  home.packages = commonPackages 
    ++ lib.optionals isLinux linuxPackages
    ++ lib.optionals isDarwin darwinPackages;
}
