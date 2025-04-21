## play with nix run command

nix run nixpkgs#nodejs_20 -- --version
nix run nixpkgs#nodejs_22 -- --version

NODE_VERSION=$(nix run nixpkgs#nodejs_18 -- --version)
echo $NODE_VERSION

PULUMI_VERSION=$(nix run nixpkgs#pulumi -- version)
echo $PULUMI_VERSION

nix run nixpkgs#gh -- --help
nix run nixpkgs#gh -- auth login

nix-collect-garbage -d
