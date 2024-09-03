#!/usr/bin/env bash

# TODO add symlink /etc/nixos/nixpkgs to the currently used nixpkgs

cd "$(dirname "$0")"
#sudo nixos-rebuild switch --flake .#$(hostname) # not needed?

#sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?
#sudo nixos-rebuild dry-activate --flake /etc/nixos#$(hostname) # not needed?
#sudo env -u NIX_PATH nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?
#sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?

opts=""

opts+=' --impure' # allow acces to /home

# FIXME doublequotes are passed as string literals ... -> TODO use bash arrays
opts+=' --builders ""' # disable builders
#opts+=' --builders jonringer'

#opts+=' --flake /home/user/src/nixos/nixos-config'

opts+=' -v' # verbose
#opts+=' -vvvv' # debug

echo "maybe run:"
echo "nix-store --verify --repair"
echo "... to fix store after writable-nix-store.js"

set -x
grep nur-packages-milahu flake.nix

echo updating flake.lock
flake_lock_bak=flake.lock.bak-$(date +%F-%H-%M-%S)
sudo cp flake.lock $flake_lock_bak
sudo nix flake lock --update-input nur-packages-milahu
diff -s -u $flake_lock_bak flake.lock

# this should be enough to build nixos flake config
set -x
sudo nixos-rebuild switch $opts --print-build-logs --show-trace "$@"
