{

  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/f5dad40450d272a1ea2413f4a67ac08760649e89"; # nixpkgs-unstable-2023-02-22
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  # too complex? now using docker for jdownloader
  #inputs.microvm.url = "github:astro/microvm.nix/f3ebf61cb123cdfd27ae9895cd468d67c3a5e112"; # 2022-05-05

  #inputs.nur.url = "github:nix-community/NUR/1ed7701bc2f5c91454027067872037272812e7a3"; # 2023-02-09
  inputs.nur.url = "github:nix-community/NUR";

  # https://github.com/nix-community/NUR/issues/254#issuecomment-1443739510
  # this breaks when the last component of the path is a symlink
  #inputs.nur-packages-milahu.url = "path:/home/user/src/milahu/symlink-to-nur-packages";
  #inputs.nur-packages-milahu.url = "git+file:///home/user/src/milahu/nur-packages?shallow=true";
  # need submodules=1 for npmlock2nix
  inputs.nur-packages-milahu.url = "git+file:///home/user/src/milahu/nur-packages?submodules=1";
  inputs.nur-packages-milahu.inputs.nixpkgs.follows = "nixpkgs";

  /*
  inputs.nur-packages-wolfangaukang.url = "git+https://codeberg.org/wolfangaukang/nix-agordoj.git";
  inputs.nur-packages-wolfangaukang.inputs.nixpkgs.follows = "nixpkgs";
  */

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, ... } @ inputs: {

    nixosConfigurations.laptop1 = inputs.nixpkgs.lib.nixosSystem rec {

      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [

        inputs.home-manager.nixosModules.home-manager

        # too simple. does not allow repoOverrides (?)
        #if true then inputs.nur.nixosModules.nur else

        ({ config, pkgs, options, ... }:
        let
          nurForPackageOverrides = getNur pkgs nurpkgsForPackageOverrides;
          nurpkgsForPackageOverrides = import inputs.nixpkgs { inherit system; };
          getNur = pkgs: nurpkgs: import inputs.nur {
            inherit pkgs nurpkgs;
            repoOverrides = {
              # FIXME not working. error: attribute 'subdl' missing
              milahu = import inputs.nur-packages-milahu { inherit pkgs; };
              #milahu-local = import inputs.nur-packages-milahu { inherit pkgs; };
              # test https://codeberg.org/wolfangaukang/nix-agordoj/issues/82
              #wolfangaukang2 = import inputs.nur-packages-wolfangaukang { inherit pkgs; };
            };
          };
        in
        {
          # FIXME not working in home.nix
          #nixpkgs.config.packageOverrides = pkgs: { nur = nurForPackageOverrides; };
          # use overlays for nix.nixPath
          nixpkgs.overlays = [ (final: prev: { nur = getNur prev prev; }) ];

          # no
          # https://haseebmajid.dev/posts/2023-06-22-til-use-nur-with-home-manager-flake/
          # enable "pkgs.nur.repos.xxx.yyy" in home.nix
          imports = [
            #inputs.nur.hmModules.nur
          ];
          # DON'T set useGlobalPackages! It's not necessary in newer
          # home-manager versions and does not work with configs using
          # nixpkgs.config`
          #home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # https://discourse.nixos.org/t/access-nur-in-imported-module-in-home-manager/18695
          # abuse the module system to pass nur to home.nix
          # configuration._module.args = { inherit nur; };
          # configuration.imports = [ ./home.nix ];
          home-manager.users.user._module.args = {
            nur = nurForPackageOverrides;
            # add pkgs.nur
            # no. error: The option `home-manager.users.user._module.args.pkgs' is defined multiple times while it's expected to be unique.
            #pkgs = pkgs // { nur = nurForPackageOverrides; };
          };

          #home-manager.users.user = import ./home.nix;
          home-manager.users.user.imports = [
            # no
            # https://old.reddit.com/r/NixOS/comments/13nangd/adding_extensions_to_firefox_using_home_manager/jl2i0t4/
            #inputs.nur.hmModules.nur
            ./home.nix
          ];
        })

        ({ config, pkgs, options, ... }: {
          nix.extraOptions = ''
            experimental-features = nix-command flakes recursive-nix ca-derivations
            #system-features = nixos-test benchmark big-parallel kvm recursive-nix
            #keep-outputs = true
            #keep-derivations = true
            #extra-sandbox-paths = /nix/var/cache/ccache /nix/var/cache/sccache

            # dont upload paths to remote, remote should download from cache.nixos.org
            builders-use-substitutes = true

            # RISKY: allow install from remote builders
            require-sigs = false

            # https://github.com/astro/microvm.nix/issues/3
            #extra-substituters = https://microvm.cachix.org
            #trusted-public-keys = microvm.cachix.org:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=

            # use only on demand: nix-build --extra-substituters ssh://jonringer.us
            #extra-substituters = ssh://jonringer.us
            #trusted-substituters = ssh://jonringer.us

            # use only 2 of 4 cores, to make laptop more quiet
            #cores = 0 # default: use all cores
            #cores = 4 # too greedy
            #cores = 3 # too greedy?
            cores = 2 # too slow
          '';
          #  require-sigs = false # pull pkgs from jonringer
          #  sandbox = false -> use ccache for qtbase etc

          #nix.package = pkgs.nixFlakes;

          #nix.package = pkgs.nix_2_6;
          #nix.package = pkgs.nixVersions.nix_2_7;
          # waiting for https://github.com/NixOS/nix/pull/7283

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

          # TODO where exactly is NIX_PATH being set?
          # NIX_PATH is not updated after "sudo nixos-rebuild switch"
          # this affects old shells and new shells.
          # /etc/profile
          #   if [ -z "$__NIXOS_SET_ENVIRONMENT_DONE" ]; then
          #       . /nix/store/fdcs873j2b3jpah4wvnqzh9fx59v3abn-set-environment
          #   fi
          # problem: __NIXOS_SET_ENVIRONMENT_DONE is already set in old shells
          # so this has no effect: source /etc/profile
          # but this works: source /etc/set-environment

          # see also:
          # nix-instantiate --find-file nixpkgs
          # via NUR/ci/nur/path.py

          # https://discourse.nixos.org/t/correct-way-to-use-nixpkgs-in-nix-shell-on-flake-based-system-without-channels/19360/3

          # https://nixos.wiki/wiki/Overlays#On_the_system_level

          # set NIX_PATH
          nix.nixPath =
            # no. this is based on the old nix channels:
            # nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels
            #options.nix.nixPath.default ++
            [
              "nixos=${inputs.nixpkgs.outPath}/nixos"
              "nixpkgs=${inputs.nixpkgs.outPath}"
              # allow all of the Nix tools to see the exact same overlay as is defined in nixpkgs.overlays
              # FIXME error: file 'nixos-config' was not found in the Nix search path (add it using $NIX_PATH or -I)
              #"nixpkgs-overlays=/etc/nixos/overlays-compat/"
            ]
          ;

          # Let 'nixos-version --json' know the Git revision of this flake.
          system.configurationRevision =
            inputs.nixpkgs.lib.mkIf (self ? rev) self.rev;
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
          nix.registry.pinpox.flake = self;
        })

        ./configuration.nix

      ];
    };

  };
}
