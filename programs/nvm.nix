{ config, pkgs, lib, ... }:
{
  # Configuração para trabalhar com ASDF (que gerencia Node.js)
  home.sessionVariables = {
    # Configurações para ASDF
    ASDF_DATA_DIR = "${config.home.homeDirectory}/.asdf";
    ASDF_CONFIG_FILE = "${config.home.homeDirectory}/.asdfrc";
  };

  # Configuração para Fish shell com ASDF
  programs.fish = lib.mkIf (config.programs.fish.enable or false) {
    shellInit = ''
      # Inicialização do ASDF
      if test -f ~/.asdf/asdf.fish
        source ~/.asdf/asdf.fish
      end
    '';
    
    shellAliases = {
      # Aliases úteis para desenvolvimento Node.js
      ni = "npm install";
      nid = "npm install --save-dev";
      nig = "npm install --global";
      nr = "npm run";
      ns = "npm start";
      nt = "npm test";
    };
  };

  # Arquivo .asdfrc com configurações padrão
  home.file.".asdfrc".text = ''
    legacy_version_file = yes
  '';
}

