_: {
  programs.tmux = {
    enable = true;
    
    # Basic tmux settings using native Home Manager options
    mouse = true;
    keyMode = "vi";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    clock24 = true;
    
    # Terminal and display settings
    terminal = "screen-256color";
    
    # Window and pane settings
    aggressiveResize = true;
    
    # Custom key bindings - only what can't be configured natively
    extraConfig = ''
      # Vi-style copy mode bindings with system clipboard integration
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      
      # System clipboard integration
      set -g set-clipboard on
      bind C-c run "tmux save-buffer - | xclip -i -sel clipboard"
      bind C-v run "tmux set-buffer $(xclip -o -sel clipboard); tmux paste-buffer"

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane resizing with repeat
      bind-key -r C-k resize-pane -U 2
      bind-key -r C-j resize-pane -D 2
      bind-key -r C-h resize-pane -L 2
      bind-key -r C-l resize-pane -R 2

      # Better integration with modern terminals
      set -g focus-events on
      set -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}
