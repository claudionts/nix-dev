{ pkgs, ... }: {
  programs.neovim = {
    enable = false;
    defaultEditor = true;
  };
}
