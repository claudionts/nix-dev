{...}: {
  imports = [
    ./home.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/packages.nix
  ];

  home.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
  };
}
