
{
  config,
  pkgs,
  ...
}: {
  virtualisation = {
    docker.enable = true;
    # docker.enableNvidia = true;
    podman.enable = true;
    kvmgt.enable = true;
    libvirtd = {
      enable = true;
      qemu.ovmf = {
        enable = true;
        packages = [pkgs.OVMFFull];
      };
    };
  };
}
