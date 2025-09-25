_: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Prefix key
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix
      
      # Enable mouse support
      set -g mouse on

      # Use vi-style key bindings
      set-window-option -g mode-keys vi

      # Enable clipboard integration (works with wl-clipboard for Wayland and xclip for X11)
      set -g set-clipboard on

      # Vi-style copy mode bindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection-and-cancel

      # System clipboard integration
      # For X11 (xclip)
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      
      # For Wayland (wl-clipboard) - uncomment if using Wayland
      # bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
      # bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "wl-copy"
      # bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"

      # Manual clipboard bindings
      bind C-c run "tmux save-buffer - | xclip -i -sel clipboard"
      bind C-v run "tmux set-buffer $(xclip -o -sel clipboard); tmux paste-buffer"

      # Pane navigation (vim-style)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane resizing
      bind-key -r -T prefix C-k resize-pane -U 2
      bind-key -r -T prefix C-j resize-pane -D 2
      bind-key -T prefix C-h resize-pane -L 2
      bind-key -r -T prefix C-l resize-pane -R 2

      # Enable focus events for better integration with editors
      set -g focus-events on

      # Increase scrollback buffer
      set -g history-limit 50000
      
      # Enable true color support
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}
