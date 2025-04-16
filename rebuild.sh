#!/usr/bin/env bash

## make the script executable
## chmod +x rebuild.sh

## This script is used to rebuild the NixOS configuration.
sudo nixos-rebuild switch --flake ~/configuration


## if param is passed to git, it will be used as the commit message and push

if [ "$1" ]; then
    git add . 
    git commit -m "$1"
    git push origin main
else
    echo "No commit message provided. Skipping git commit and push."
fi
