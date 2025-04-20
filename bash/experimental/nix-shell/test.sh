#!/usr/bin/env bash

# experimenting with nix shell 
nix shell nixpkgs#home-manager nixpkgs#gh --command sh -c " \
  echo -e '[+] $(gh --version)'
  echo '[+] home-manager:' 
  home-manager --version 

  echo -e '[+todo]: -----------------------------------------------'
  echo -e 'gh auth login' 
  echo -e '&& gh repo clone jalalhejazi/flake-test -- --depth=1 '
  echo -e '&& home-manager switch --flake ./flake-test#hello  '
"

