/*
nixos-rebuild switch --flake .#laptop1 
*/

{
  description = "An example NixOS configuration";

/*
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nur = { url = "github:nix-community/NUR"; };
  };
*/

  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03"; # stable
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/1b9dbf407cf8ab3502db9d884288de93d53351dc"; # 2021-10-03
# use (3 weeks) old version to use binary cache

inputs.nur.url = "github:nix-community/NUR/2ed3b8f5861313e9e8e8b39b1fb05f3a5a049325"; # todo update



  outputs = inputs:
    /* ignore:: */ let ignoreme = ({config,lib,...}: with lib; { system.nixos.revision = mkForce null; system.nixos.versionSuffix = mkForce "pre-git"; }); in
  {
    nixosConfigurations = {

      laptop1 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          /* ignore */ ignoreme # ignore this; don't include it; it is a small helper for this example
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}

