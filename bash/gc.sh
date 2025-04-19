#!/usr/bin/env bash

## clean up
gc
docker container rm $(docker container ls -aq) -f
docker image rm $(docker image ls -aq) -f