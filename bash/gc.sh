#!/usr/bin/env bash

## manually remove old nix generations
## gc
## nix-collect-garbage -d


## remove alle docker containers and images
docker container rm $(docker container ls -aq) -f
docker image rm $(docker image ls -aq) -f