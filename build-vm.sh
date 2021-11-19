#!/bin/sh

#nixos-rebuild build-vm --flake .#nixosConfigurations.Olimpo.config.system.build.toplevel
#nixos-rebuild build-vm --flake .#nixosConfigurations.$(hostname).config.system.build.toplevel
nixos-rebuild build-vm --flake .#$(hostname)
#.config.system.build.toplevel
