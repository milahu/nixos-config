#!/usr/bin/env bash

cd "$(dirname "$0")"

nixos-rebuild switch --flake .#$(hostname)
