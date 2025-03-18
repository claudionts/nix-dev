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
    asdf
    gopls
    elixir-ls
  ];
}
