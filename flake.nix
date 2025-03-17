{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      # Criação de uma derivação para o Home Manager
      homeConfigurations.claudio = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home-manager.nix ];
      };

      # Aqui criamos a derivação para o Home Manager, mas agora sem a tentativa de acessar 'activationPackage'
      # O correto seria usar a configuração ativa diretamente
      defaultPackage.x86_64-linux = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home-manager.nix ];
      };
    };
}

