#!/usr/bin/env bash


#cd "$(dirname "$0")"
#sudo nixos-rebuild switch --flake .#$(hostname) # not needed?

sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) # not needed?

#sudo nixos-rebuild switch
