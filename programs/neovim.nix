{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      xclip
      xsel
      wl-clipboard
    ];
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      vim.opt.number = true

      local o = vim.o
      local g = vim.g

      o.clipboard = "unnamedplus"

      o.number = true
      vim.opt.numberwidth = 1

      o.swapfile = false

      g.markdown_fenced_languages = {
          "python", "elixir", "bash", "dockerfile", 'sh=bash'
      }
    "ignore config file"
    '';
  };
}
