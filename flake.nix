{
  description = "Ambiente pessoal do Claudio com Nix Flakes e Home Manager - Multi-plataforma";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # Stable tem mais binários
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # Para Neovim recente
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }: let
    system-linux = "x86_64-linux";
    system-darwin-arm = "aarch64-darwin";
    system-darwin-intel = "x86_64-darwin";

    # Pacotes stable
    pkgs-linux = nixpkgs.legacyPackages.${system-linux};
    pkgs-darwin-arm = nixpkgs.legacyPackages.${system-darwin-arm};
    pkgs-darwin-intel = nixpkgs.legacyPackages.${system-darwin-intel};
    
    # Pacotes unstable (para Neovim)
    pkgs-unstable-linux = nixpkgs-unstable.legacyPackages.${system-linux};
    pkgs-unstable-darwin-arm = nixpkgs-unstable.legacyPackages.${system-darwin-arm};
    pkgs-unstable-darwin-intel = nixpkgs-unstable.legacyPackages.${system-darwin-intel};
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
            # Overlay para Neovim unstable
            nixpkgs.overlays = [
              (final: prev: {
                neovim-unwrapped = pkgs-unstable-linux.neovim-unwrapped;
              })
            ];
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
            # Overlay para Neovim unstable
            nixpkgs.overlays = [
              (final: prev: {
                neovim-unwrapped = pkgs-unstable-darwin-arm.neovim-unwrapped;
              })
            ];
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
            # Overlay para Neovim unstable
            nixpkgs.overlays = [
              (final: prev: {
                neovim-unwrapped = pkgs-unstable-darwin-intel.neovim-unwrapped;
              })
            ];
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
            # Overlay para Neovim unstable
            nixpkgs.overlays = [
              (final: prev: {
                neovim-unwrapped = pkgs-unstable-linux.neovim-unwrapped;
              })
            ];
          }
        ];
      };
    };
  };
}
