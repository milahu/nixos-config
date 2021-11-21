/*

NOTE
only nixpkgs are pinned to git commit
nixos is stable channel nixos-21.05

nix-channel --add https://nixos.org/channels/nixos-21.05 nixos 

nix-channel --update 

nix-channel --list
nixos https://nixos.org/channels/nixos-21.05

*/

{

  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/5d517bc079f75fb400d6e9d6432938820c3013cf"; # 2021-10-24

  inputs.nur.url = "github:nix-community/NUR/fc0758e2f8aa4dac7c4ab42860f07487b1dcadea"; # 2021-11-21

#/*
  #inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.home-manager.url = "github:nix-community/home-manager/2452979efe92128b03e3c27567267066c2825fab"; # 2021-11-19

  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
#*/

  outputs = inputs: {

    nixosConfigurations.laptop1 = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Things in this set are passed to modules and accessible
      # in the top-level arguments (e.g. `{ pkgs, lib, inputs, ... }:`).
      specialArgs = {
        inherit inputs;
      };
      modules = [
#/*
        inputs.home-manager.nixosModules.home-manager
#*/

        ({ pkgs, ... }: {
          nix.extraOptions = ''
            experimental-features = nix-command flakes
            keep-outputs = true
            keep-derivations = true
          '';
          nix.package = pkgs.nixFlakes;
          nix.registry.nixpkgs.flake = inputs.nixpkgs;

/* set $NIX_PATH
          nix.nixPath = [
            "nixpkgs=${inputs.nixpkgs}"
            "nixos-config=/etc/nixos/configuration.nix"
            "${inputs.nixpkgs}/nixos"
          ];
*/

#/*
          home-manager.useGlobalPkgs = true;
#*/
        })

        ./configuration.nix

        { nixpkgs.overlays = [ nur.overlay ]; }

/* TODO
{
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        mic92 = import ../nur-packages { inherit pkgs; };
        ## remote locations are also possible:
        # mic92 = import (builtins.fetchTarball "https://github.com/your-user/nur-packages/archive/master.tar.gz") { inherit pkgs; };
      };
    };
  };
}
*/

      ];
    };

  };
}
