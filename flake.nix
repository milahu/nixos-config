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
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/5d517bc079f75fb400d6e9d6432938820c3013cf"; # 2021-10-24
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/19574af0af3ffaf7c9e359744ed32556f34536bd"; # nixpkgs-unstable-2022-02-17
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/7a3e6d6604ad99c77e7a98943734bdeea564bff2"; # nixpkgs-unstable-2022-03-03
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/e9545762b032559c27d8ec9141ed63ceca1aa1ac"; # nixpkgs-unstable-2022-03-11
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/30d3d79b7d3607d56546dd2a6b49e156ba0ec634"; # nixpkgs-unstable-2022-03-25 will build ungoogled-chromium ...
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/05ced71757730406ca3eb3e58503f05334a6057d"; # nixpkgs-unstable-2022-05-01 BROKEN
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/aae4fc3e877a1eeb253cae1ff619cde20103a62d"; # nixpkgs-unstable-2022-05-02
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/4ca69abaadb6593995da90eab8f5d5faadf06a57"; # nixpkgs-unstable-2022-06-01
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/d4f5738137891301b25081f33c493ee033353c8b"; # nixpkgs-unstable-2022-06-08
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/12363fb6d89859a37cd7e27f85288599f13e49d9"; # nixpkgs-unstable-2022-08-03
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/b00aa8ded743862adc8d6cd3220e91fb333b86d3"; # nixpkgs-unstable-2022-08-13
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/178fea1414ae708a5704490f4c49ec3320be9815"; # nixos-22.05 2022-09-15
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/3dd0d739d2925626d46302b59299ef4c0403e0bc"; # nixpkgs-unstable-2022-10-03
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/c45e994e4a94f87079beaa21ac0a4e090f96027e"; # nixpkgs-unstable-2022-09-20
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/1e53371bdabd9f3a5f267ccc6af5bab1d289fa69"; # nixpkgs-unstable-2022-11-04
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/2b34f950744ce16fa7e97dad362cda680f59fa4b"; # nixpkgs-unstable-2023-01-23

  # https://github.com/NixOS/nix/pull/7283
# TODO restore
  #inputs.nixSource.url = "github:NixOS/nix/62960f32915909a5104f2ca3a32b25fb3cfd34c7";

  # debug; enabling ca-derivations can cause deadlock on "waiting for exclusive access to the Nix store for ca drvs..."
  # https://github.com/NixOS/nix/issues/6666
  #inputs.nixSource.url = "github:milahu/nix/d0d73ff53ea296b0e52c1e7cfb8974316b72ba89";
  inputs.nixSource.url = "github:milahu/nix/204663327a5e4984457e913d8c341275747f4391";

  # https://github.com/NixOS/nixpkgs/commits/master
  # https://status.nixos.org/
  # https://github.com/NixOS/nixpkgs/commits/nixpkgs-unstable

  # too complex? now using docker for jdownloader
  #inputs.microvm.url = "github:astro/microvm.nix/f3ebf61cb123cdfd27ae9895cd468d67c3a5e112"; # 2022-05-05

  #inputs.nur.url = "github:nix-community/NUR";
  #inputs.nur.url = "github:nix-community/NUR/fc0758e2f8aa4dac7c4ab42860f07487b1dcadea"; # 2021-11-21
  #inputs.nur.url = "github:nix-community/NUR/bc8d5b8cda77bf9660152b3c781478d5759e5450"; # 2022-02-17
  #inputs.nur.url = "github:nix-community/NUR/4aa31a863e53a91c5148e28e3cc6e407a45a6b73"; # 2022-05-01
  inputs.nur.url = "github:nix-community/NUR/1ed7701bc2f5c91454027067872037272812e7a3"; # 2023-02-09

  #inputs.kapack.url = "path:/home/auguste/dev/nur-kapack"; # my local nur.repos.kapack

  # https://github.com/nix-community/NUR
  # TODO update

  inputs.nur.inputs.nixpkgs.follows = "nixpkgs";

  # workaround for https://github.com/NixOS/nix/issues/6572
  #nix.package = pkgs.nixUnstable;
  #inputs.nix.url = "github:NixOS/nix/28309352d991f50c9d8b54a5a0ee99995a1a5297";
  # 2022-03-31
  # nix (Nix) 2.8.0pre20220530_af23d38
  # error: path xxxxxxxx is not valid
  #inputs.nix.url = "github:NixOS/nix/f41c18b2210ac36743f03ea218860b7941f4264e";
  # 2022-03-31
  #inputs.nix.url = "github:NixOS/nix/69c6fb12eea414382f0b945c0d6c574c43c7c9a3";
  # 2022-04-19
  # nix 2.8.0 stable release
  #inputs.nix.url = "github:NixOS/nix/ffe155abd36366a870482625543f9bf924a58281";
  # 2.7.0

#/*
  #inputs.home-manager.url = "github:nix-community/home-manager/master";
  inputs.home-manager.url = "github:nix-community/home-manager/2452979efe92128b03e3c27567267066c2825fab"; # 2021-11-19

  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
#*/

#  outputs = inputs: {
#  outputs = { self, ... }@inputs: with inputs; {
  outputs = { self, ... }@inputs: {

    nixosConfigurations.laptop1 = inputs.nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      # Things in this set are passed to modules and accessible
      # in the top-level arguments (e.g. `{ pkgs, lib, inputs, ... }:`).
      specialArgs = {
        inherit inputs;
      };
  #nurpkgs = import inputs.nixpkgs { inherit system; };

      modules = [


   # https://github.com/nix-community/NUR/issues/254
       {
         nixpkgs.config.packageOverrides = pkgs: {
            nur = import inputs.nur {
              #inherit pkgs nurpkgs; # error: called with unexpected argument 'nurpkgs'
              inherit pkgs;
  nurpkgs = import inputs.nixpkgs { inherit system; };
              #repoOverrides = { kapack = import kapack { inherit pkgs; }; };
            };
          };
        }
/*
   {
    nixpkgs.overlays = [
      (final: prev: {
        nur = import inputs.nur {
          nurpkgs = prev;
          pkgs = prev;
          #repoOverrides = { kapack = import kapack { pkgs = prev; }; };
        };
      })
    ];
   } 
*/

        #inputs.nur.nixosModules.nur # error: attribute 'nixosModules' missing



#/*
        inputs.home-manager.nixosModules.home-manager
#*/

#            experimental-features = nix-command flakes

        # NOTE "ca-derivations" breaks nix https://github.com/NixOS/nix/issues/6666

        ({ pkgs, ... }: {
          nix.extraOptions = ''
            # good
            #experimental-features = nix-command flakes recursive-nix
            # bad
            experimental-features = nix-command flakes recursive-nix ca-derivations

            # force rebuild 2

            #system-features = nixos-test benchmark big-parallel kvm recursive-nix
            #keep-outputs = true
            #keep-derivations = true
            #extra-sandbox-paths = /nix/var/cache/ccache /nix/var/cache/sccache

            builders-use-substitutes = true
            # dont upload paths to remote, remote should download from cache.nixos.org

            # RISKY: allow install from remote builders
            require-sigs = false

            # https://github.com/astro/microvm.nix/issues/3
            #extra-substituters = https://microvm.cachix.org
            #trusted-public-keys = microvm.cachix.org:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=

            #extra-substituters = ssh://jonringer.us
            #trusted-substituters = ssh://jonringer.us
            # use only on demand: nix-build --extra-substituters ssh://jonringer.us

            # use only 2 of 4 cores, to make laptop more quiet
            #cores = 0 # default: use all cores
            #cores = 4
            cores = 3
            #cores = 2 # too slow
          '';
          #  require-sigs = false # pull pkgs from jonringer
          #  sandbox = false -> use ccache for qtbase etc

          #nix.package = pkgs.nixFlakes;

          # workaround for https://github.com/NixOS/nix/issues/6572
/*
nix.package = pkgs.nixUnstable.overrideAttrs (old: {
  #version = "2.8.0-unstable-workaround-nix-issue-6572";
  version = "2.7.0";
  src = inputs.nix;
});
*/

  #nix.package = pkgs.nix_2_6;
  #nix.package = pkgs.nixVersions.nix_2_7;
  # waiting for https://github.com/NixOS/nix/pull/7283

/*
  nix.package = pkgs.nixVersions.nix_2_8.overrideAttrs (drv: rec {
    version = "2.7.0";
    sha256 = "sha256-m8tqCS6uHveDon5GSro5yZor9H+sHeh+v/veF1IGw24=";
    src = pkgs.fetchFromGitHub { owner = "NixOS"; repo = "nix"; rev = version; inherit sha256; };
    patches = [
      # remove when there's a 2.7.1 release
      # https://github.com/NixOS/nix/pull/6297
      # https://github.com/NixOS/nix/issues/6243
      # https://github.com/NixOS/nixpkgs/issues/163374
      (pkgs.fetchpatch {
        url = "https://github.com/NixOS/nix/commit/c9afca59e87afe7d716101e6a75565b4f4b631f7.patch";
        sha256 = "sha256-xz7QnWVCI12lX1+K/Zr9UpB93b10t1HS9y/5n5FYf8Q=";
      })
    ];
  });
*/



/* TODO use pkgs.nixVersions.nix_2_7 from nixpkgs. was restored on 2022-08-23
nix.package =
  let
    pkgs = import (builtins.fetchTarball {
        # nix 2.7 @ https://lazamar.co.uk/nix-versions/
        #url = "https://github.com/NixOS/nixpkgs/archive/bf972dc380f36a3bf83db052380e55f0eaa7dcb6.tar.gz";
        # 1 commit before b2eea05b06baa2886039d61485d37c338ad3d578 (nixVersions: remove 2.4 to 2.7)
        url = "https://github.com/NixOS/nixpkgs/archive/3faccf8814488deb8c4226455426c0fcac81ac7b.tar.gz";
    }) {};
  in
  pkgs.nixVersions.nix_2_7;
*/

  # trying to reproduce
  # https://github.com/NixOS/nix/issues/6572
  # nix-build: requires non-existent output 'out' from input derivation
  # latest version: nix 2.10.3
  #nix.package = pkgs.nixVersions.nix_2_8; # nix (Nix) 2.8.1


/*
  nix.package = pkgs.nix.overrideAttrs (old: {
    version = "2.10.3-git-de439ebba";
    src = /home/user/src/nix/nix-debug-ca-lock-nix-2.10.3-src-for-system-nix;
    doInstallCheck = false; # tests fail with custom log messages
  }); # nix (Nix) 2.8.1
*/




/*
  nix.package =
  let
  storeDir = "/nix/store";
  stateDir = "/nix/var";
  confDir = "/etc";
  aws-sdk-cpp-nix = (pkgs.aws-sdk-cpp.override {
    apis = [ "s3" "transfer" ];
    customMemoryManagement = false;
  }).overrideDerivation (args: {
    patches = (args.patches or [ ]) ++ [ "${inputs.nixpkgs}/pkgs/tools/package-management/nix/patches/aws-sdk-cpp-TransferManager-ContentEncoding.patch" ];

    # only a stripped down version is build which takes a lot less resources to build
    requiredSystemFeatures = null;
  });

  boehmgc-nix_2_3 = pkgs.boehmgc.override { enableLargeConfig = true; };

  boehmgc-nix = boehmgc-nix_2_3.overrideAttrs (drv: {
    # Part of the GC solution in https://github.com/NixOS/nix/pull/4944
    patches = (drv.patches or [ ]) ++ [ "${inputs.nixpkgs}/pkgs/tools/package-management/nix/patches/boehmgc-coroutine-sp-fallback.patch" ];
  });

  common = args:
    with pkgs;
    callPackage
      (import "${inputs.nixpkgs}/pkgs/tools/package-management/nix/common.nix" ({ inherit lib fetchFromGitHub curl; } // args))
      {
        inherit (pkgs) Security;
        inherit storeDir stateDir confDir;


        boehmgc = boehmgc-nix;
        aws-sdk-cpp = aws-sdk-cpp-nix;
      };
  in
  common {
    version = "2.7.0";
    sha256 = "sha256-m8tqCS6uHveDon5GSro5yZor9H+sHeh+v/veF1IGw24=";
    patches = [
      # remove when there's a 2.7.1 release
      # https://github.com/NixOS/nix/pull/6297
      # https://github.com/NixOS/nix/issues/6243
      # https://github.com/NixOS/nixpkgs/issues/163374
      (pkgs.fetchpatch {
        url = "https://github.com/NixOS/nix/commit/c9afca59e87afe7d716101e6a75565b4f4b631f7.patch";
        sha256 = "sha256-xz7QnWVCI12lX1+K/Zr9UpB93b10t1HS9y/5n5FYf8Q=";
      })
    ];
  };
*/



  #nix.package = pkgs.nixVersions.nix_2_8;

          #nix.registry.nixpkgs.flake = inputs.nixpkgs;

# https://github.com/pinpox/nixos/commit/d2492dc2908207ad6e7858bc796593fc78414f12
# https://github.com/pinpox/nixos/blob/d2492dc2908207ad6e7858bc796593fc78414f12/flake.nix
                  # Set the $NIX_PATH entry for nixpkgs. This is necessary in
                  # this setup with flakes, otherwise commands like `nix-shell
                  # -p pkgs.htop` will keep using an old version of nixpkgs.
                  # With this entry in $NIX_PATH it is possible (and
                  # recommended) to remove the `nixos` channel for both users
                  # and root e.g. `nix-channel --remove nixos`. `nix-channel
                  # --list` should be empty for all users afterwards
          nix.nixPath = [
            "nixos=${inputs.nixpkgs}/nixos" "nixpkgs=${inputs.nixpkgs}"
          ];
# after `sudo nix-channel --remove nixos` and `sudo nix-channel --update`
# not working
# workaround:
# /nix/var/nix/profiles/per-user/root/channels-11-dir-workaround/
# /etc/nixos/debug/flake.nix -> print nix-store location of nixpkgs
# symlink nixpkgs to /nix/var/nix/profiles/per-user/root/channels-11-dir-workaround/nixos
# add manifest.nix

/*
nix repl
:l <nixpkgs>
pkgs.lib.nixpkgsVersion # deprecated for pkgs.lib.version
# old 21.11pre331460.931ab058daa
# new TODO
*/

              # Let 'nixos-version --json' know the Git revision of this flake.
              system.configurationRevision =
                inputs.nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs.flake = inputs.nixpkgs;
              nix.registry.pinpox.flake = self;

                  nixpkgs.overlays = [
                    #self.overlay
                    #inputs.nur.overlay
                    # neovim-nightly.overlay
                  ];



                  # DON'T set useGlobalPackages! It's not necessary in newer
                  # home-manager versions and does not work with configs using
                  # nixpkgs.config`
#                  home-manager.useUserPackages = true;


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

#### FIXME        
#{ nixpkgs.overlays = [ nur.overlay ]; }
#{ nixpkgs.overlays = [ inputs.nur.overlay ]; } # TODO remove?

/*
{
  packageOverrides = pkgs: {
    #nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    nur = import inputs.nur {
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
