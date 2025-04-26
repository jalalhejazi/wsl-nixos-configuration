## build dynamic configuration in git then build flake

```bash
if [ "$PARAM_VALUES" != "" ]; then
  echo -ne "With values\n" >/dev/stderr
  echo "$PARAM_VALUES" > values.json
  nix-shell -p git --run 'git add values.json'
fi

nix build ".#kubernetesConfiguration"
```


## fetch from url
```bash
nix-prefetch-url --unpack --print-path https://github.com/NixOS/patchelf/archive/0.8.tar.gz
```



## build k8s with nix flake video
- https://youtu.be/SEA1Qm8K4gY?si=nt6xXDiDIftrU8O4


