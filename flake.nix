{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/f5dad40450d272a1ea2413f4a67ac08760649e89"; # nixpkgs-unstable-2023-02-22

  # too complex? now using docker for jdownloader
  #inputs.microvm.url = "github:astro/microvm.nix/f3ebf61cb123cdfd27ae9895cd468d67c3a5e112"; # 2022-05-05

  inputs.nur.url = "github:nix-community/NUR/1ed7701bc2f5c91454027067872037272812e7a3"; # 2023-02-09
  inputs.nur.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nur-packages-milahu.url = "path:/home/milahu/src/milahu/nur-packages"; # my local nur.repos.kapack

  inputs.home-manager.url = "github:nix-community/home-manager/2452979efe92128b03e3c27567267066c2825fab"; # 2021-11-19
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, ... }@inputs: {

    nixosConfigurations.laptop1 = inputs.nixpkgs.lib.nixosSystem rec {

      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [

        ./configuration.nix

        (let
          nurpkgsForPackageOverrides = import inputs.nixpkgs { inherit system; };
          getNur = pkgs: nurpkgs: import inputs.nur {
            inherit pkgs nurpkgs;
            #repoOverrides = { paul = import paul { inherit pkgs; }; };
            repoOverrides = {
              milahu = import inputs.nur-packages-milahu { inherit pkgs; };
              # mic92 = import (builtins.fetchTarball "https://github.com/your-user/nur-packages/archive/master.tar.gz") { inherit pkgs; };
            };
          };
        in
        {
          # error: undefined variable 'nur'
          #nixpkgs.config.packageOverrides = pkgs: { nur = getNur pkgs nurpkgsForPackageOverrides; };
          # error: undefined variable 'nur'
          nixpkgs.overlays = [ (final: prev: { nur = getNur prev prev; }) ];
        })

        inputs.home-manager.nixosModules.home-manager

        #experimental-features = nix-command flakes
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
                  #home-manager.useUserPackages = true;


          /* set $NIX_PATH
          nix.nixPath = [
            "nixpkgs=${inputs.nixpkgs}"
            "nixos-config=/etc/nixos/configuration.nix"
            "${inputs.nixpkgs}/nixos"
          ];
          */

          home-manager.useGlobalPkgs = true;
        })

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
