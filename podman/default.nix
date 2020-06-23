{ config, pkgs, ... }:

with import <nixpkgs> {};
with builtins;
with lib;

let

  # Provides a fake "docker" binary mapping to podman
  dockerCompat = pkgs.runCommandNoCC "docker-podman-compat" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.podman}/bin/podman $out/bin/docker
  '';

in {
  home.packages = [
    dockerCompat
    unstable.podman
    unstable.podman-compose
    pkgs.runc
    pkgs.skopeo
    pkgs.buildah
    pkgs.cni-plugins
    pkgs.conmon  # Container runtime monitor
    pkgs.skopeo  # Interact with container registry
    pkgs.slirp4netns  # User-mode networking for unprivileged namespaces
    pkgs.fuse-overlayfs  # CoW for images, much faster than default vfs
  ];

  home.file = {
    ".config/containers/registries.conf".text = ''
      [registries.search]
      registries = ['docker.io']

      [registries.block]
      registries = []
    '';

    ".config/containers/libpod.conf".text = ''
          runtime_path= ["${pkgs.runc}/bin/runc"]
          conmon_path= ["${pkgs.conmon}/bin/conmon"]
          cni_plugin_dir = ["${pkgs.cni-plugins}/bin/"]
          network_cmd_path = "${pkgs.slirp4netns}/bin/slirp4netns"
          cgroup_manager = "systemd"
          cni_config_dir = "/etc/cni/net.d/"
          cni_default_network = "podman"
          # pause
          pause_image = "k8s.gcr.io/pause:3.1"
          pause_command = "/pause"
        '';

    ".config/containers/policy.json".text = ''
        {
          "default": [
            {
              "type": "insecureAcceptAnything"
            }
          ],
          "transports": {
            "docker-daemon": {
              "": [{"type":"insecureAcceptAnything"}]
            }
          }
        }
    '';
  };
}
