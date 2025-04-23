#!/usr/bin/env bash
cd ~/configuration
git add .
git commit --amend --no-edit
sudo nixos-rebuild switch --flake ~/configuration --refresh
