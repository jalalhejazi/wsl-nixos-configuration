
## build docker image 

- https://nix.dev/tutorials/nixos/building-and-running-docker-images

```bash
docker load < $(nix-build hello-docker.nix)
Loaded image: hello-docker:9d1j09h920jp8jq4ax7l364j3mqm7x5z

docker run -t hello-docker:9d1j09h920jp8jq4ax7l364j3mqm7x5z
Hello, world!

```