# ###########################################
# run in interactive shell one line at a time
#############################################


## start nix shell with home-manager
nix shell nixpkgs#home-manager
home-manager --version 



## create a new home-manager flakes (home.nix and flake.nix)
home-manager init . 
vim ./home.nix 
vim ./flake.nix 




## Build and activate configuration
home-manager switch --flake .#jalal



## validate the current packages 
home-manager packages

# hello 
# my-hello 

