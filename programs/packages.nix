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
    tmux
    xclip
    gcc
    neovim
    asdf-vm
    gopls
    go
    elixir-ls
    luajitPackages.luarocks
  ];
}
