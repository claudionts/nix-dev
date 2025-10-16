{
  description = "Ambiente pessoal do Claudio com Nix Flakes e Home Manager - Multi-plataforma";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system-linux = "x86_64-linux";
    system-darwin = "aarch64-darwin";

    pkgs-linux = nixpkgs.legacyPackages.${system-linux};
    pkgs-darwin = nixpkgs.legacyPackages.${system-darwin};
  in {
    homeConfigurations = {
      # Configuração para Linux
      "claudio@linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-linux;
        modules = [
          ./home-manager.nix
          {
            nixpkgs.config.allowUnfree = true;
            home = {
              username = "claudio";
              homeDirectory = "/home/claudio";
              stateVersion = "24.05";
            };
            targets.genericLinux.enable = true;
          }
        ];
      };

      # Configuração para macOS
      "claudio@darwin" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-darwin;
        modules = [
          ./home-manager.nix
          {
            nixpkgs.config.allowUnfree = true;
            home = {
              username = "claudio";
              homeDirectory = "/Users/claudio";
              stateVersion = "24.05";
            };
          }
        ];
      };

      # Configuração padrão (Linux)
      claudio = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-linux;
        modules = [
          ./home-manager.nix
          {
            nixpkgs.config.allowUnfree = true;
            home = {
              username = "claudio";
              homeDirectory = "/home/claudio";
              stateVersion = "24.05";
            };
            targets.genericLinux.enable = true;
          }
        ];
      };
    };
  };
}
