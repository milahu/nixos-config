#!/usr/bin/env bash

# from flakes to non-flakes
export NIX_PATH="$NIX_PATH:nixos-config=/etc/nixos/configuration.nix"

exec sudo nixos-rebuild switch
