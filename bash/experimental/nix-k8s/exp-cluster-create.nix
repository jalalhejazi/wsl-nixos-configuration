{ config, lib, options, ... }: {
  clusters.nixbox = {
    ciliumID = 11;
    apiServer = "10.224.1.41";

    enableMonitoring = true;

    apps = {
      cilium-bgp.enable = true;
      cert-manager-cilium-issuer = {
        enable = true;
        values.vault_mount = "k8s-nixbox";
      };
    };
  };
}
