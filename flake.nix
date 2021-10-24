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
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/5d517bc079f75fb400d6e9d6432938820c3013cf"; # 2021-10-24
# use (3 weeks) old version to use binary cache

#inputs.nur.url = "github:nix-community/NUR/2ed3b8f5861313e9e8e8b39b1fb05f3a5a049325"; # todo update
inputs.nur.url = "github:nix-community/NUR/f50850b1e860a87ae725bf9209fbdc6fb0a9657c";

/*
inputs.nur.url = "https://github.com/nix-community/NUR/commit/f50850b1e860a87ae725bf9209fbdc6fb0a9657c";
error: input 'https://github.com/nix-community/NUR/commit/f50850b1e860a87ae725bf9209fbdc6fb0a9657c' is unsupported
TODO parse
*/

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

