{

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/e9545762b032559c27d8ec9141ed63ceca1aa1ac"; # nixpkgs-unstable-2022-03-11

  outputs = { self, ... }@inputs:
  let
    system = "x86_64-linux";
  in
  with inputs;
  {
    defaultPackage.${system} = inputs.nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
      name = "test";
      dontUnpack = true;
      buildPhase = ''
        echo inputs.nixpkgs = ${inputs.nixpkgs}
        exit 1
      '';
    };
  };

}
