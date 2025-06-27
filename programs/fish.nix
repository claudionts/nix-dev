{ pkgs, lib, ... }:
{
  programs.fish.enable = true;

  programs.fish.interactiveShellInit = ''
    set -U fish_greeting ""
    set -U EDITOR nvim
  '';

  programs.fish.shellAliases = {
    g = "git";
    gc = "git commit";
    gpl = "git pull -p";
    gst = "git status";
    ga = "git add";
    gck = "git checkout";
    gl = "git log";
    gp = "git push";
  };
}

