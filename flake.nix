{
  description = "Ambiente pessoal do Claudio com Nix Flakes e Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    asdf-vm.url = "github:asdf-vm/asdf";
    asdf-vm.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    homeConfig = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      modules = [
        ./home-manager.nix
        {
          home.username = "claudio";
          home.homeDirectory = "/home/claudio";
          home.stateVersion = "23.11";
        }
      ];
    };
  in {
    # Criando a configuração do home manager para o usuário
    homeConfigurations.claudio = homeConfig;

    # Garantir que o flake exporte a configuração correta como um pacote/derivado
    defaultPackage.x86_64-linux = homeConfig.activationPackage;
  };
}
