{
  description = "Ambiente pessoal do Claudio com Nix Flakes e Home Manager";

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
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations = {
      claudio = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager.nix
          {
            nixpkgs.config.allowUnfree = true;
            home = {
              username = "claudio";
              homeDirectory = "/home/claudio";
              stateVersion = "24.05";
            };
          }
        ];
      };
    };
  };
}
