
{
  config,
  pkgs,
  ...
}: {
  virtualisation = {
    docker.enable = true;
    podman.enable = true;
    kvmgt.enable = true;
    libvirtd = {
      enable = true;
      allowedBridges = [
        "virbr0"
        "nm-bridge"
      ];
      qemu.runAsRoot = false;
      qemu.ovmf = {
        enable = true;
        packages = [pkgs.OVMFFull];
      };
    };
  };
}