{pkgs, ...}: {
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
    tmux
    xclip
    gcc
    neovim
    asdf-vm  # Restaurando o ASDF
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
    libxml2.dev
    libxslt.dev
    zlib.dev
  ];
 }
