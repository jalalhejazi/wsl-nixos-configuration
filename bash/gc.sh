#!/usr/bin/env bash

## https://nix.dev/manual/nix/2.26/package-management/garbage-collection
## gc
## nix-collect-garbage -d


## remove alle docker containers and images
docker container rm $(docker container ls -aq) -f
docker image rm $(docker image ls -aq) -f
