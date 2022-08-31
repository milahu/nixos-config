#!/usr/bin/env bash

# TODO add symlink /etc/nixos/nixpkgs to the currently used nixpkgs

#cd "$(dirname "$0")"
#sudo nixos-rebuild switch --flake .#$(hostname) # not needed?

#sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?
#sudo nixos-rebuild dry-activate --flake /etc/nixos#$(hostname) # not needed?
#sudo env -u NIX_PATH nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?
#sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?

opts='--impure' # allow acces to /home
#opts='--builders ""'

#opts+=' --flake /home/user/src/nixos/nixos-config'

echo "maybe run:"
echo "nix-store --verify --repair"
echo "... to fix store after writable-nix-store.js"

# this should be enough to build nixos flake config
sudo nixos-rebuild switch $opts --builders "" --print-build-logs "$@"
