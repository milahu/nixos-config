#!/usr/bin/env bash


#cd "$(dirname "$0")"
#sudo nixos-rebuild switch --flake .#$(hostname) # not needed?

#sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?
#sudo nixos-rebuild dry-activate --flake /etc/nixos#$(hostname) # not needed?
#sudo env -u NIX_PATH nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?
#sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?

opts='--impure' # allow acces to /home

sudo nixos-rebuild switch $opts "$@" # should be enough
