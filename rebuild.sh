#!/usr/bin/env bash

## make the script executable
## chmod +x rebuild.sh


## This script is used to rebuild the NixOS configuration.
sudo nixos-rebuild switch --flake ~/configuration


