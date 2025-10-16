{
  description = "Ambiente pessoal do Claudio com Nix Flakes e Home Manager - Multi-plataforma";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # Stable tem mais binários
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system-linux = "x86_64-linux";
    system-darwin-arm = "aarch64-darwin";
    system-darwin-intel = "x86_64-darwin";

    pkgs-linux = nixpkgs.legacyPackages.${system-linux};
    pkgs-darwin-arm = nixpkgs.legacyPackages.${system-darwin-arm};
    pkgs-darwin-intel = nixpkgs.legacyPackages.${system-darwin-intel};
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

      # Configuração para macOS (Apple Silicon)
      "claudio@darwin" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-darwin-arm;
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

      # Configuração para macOS Intel
      "claudio@darwin-intel" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-darwin-intel;
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
