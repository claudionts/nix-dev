{ ... }: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -g focus-events on
      set-option -a terminal-features 'rio:RGB'

      set -g default-command fish
      set -g history-limit 4000
    '';
  };
}
