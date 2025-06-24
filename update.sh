#!/bin/sh

cd "$(dirname "$0")"

nix flake update
