{
  description = "Ambiente pessoal do Claudio com Nix Flakes e Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    homeConfigurations."claudio" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit nixpkgs; };
      modules = [
        ./home-manager.nix
        {
          home.username = "claudio";
          home.homeDirectory = "/home/claudio";
          home.stateVersion = "23.11";
        }
      ];
    };
  };
}

