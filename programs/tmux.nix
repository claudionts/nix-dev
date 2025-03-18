{ ... }: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind C-b
      set -g prefix C-a
      set -g mouse on

      set-window-option -g mode-keys vi

      bind C-c run "tmux save-buffer - | xclip -i -sel clip"
      bind C-v run "tmux set-buffer $(xclip -o -sel clip); tmux paste-buffer"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      set -g @plugin 'erikw/tmux-powerline'


      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind-key -r -T prefix       C-k              resize-pane -U 2 
      bind-key -r -T prefix       C-j            resize-pane -D 2
      bind-key -r -T prefix       C-h            resize-pane -L 2
      bind-key -r -T prefix       C-l           resize-pane -R 2
    '';
  };
}
