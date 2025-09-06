_: {
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_greeting ""
        set -U EDITOR nvim
      '';
      shellAliases = {
        g = "git";
        gc = "git commit";
        gpl = "git pull -p";
        gst = "git status";
        ga = "git add";
        gck = "git checkout";
        gl = "git log";
        gp = "git push";
      };
    };
  };
}
