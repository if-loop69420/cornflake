{
  config,
  pkgs,
  ...
}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    resumeDevice = "/dev/nvme0n1p3";
    binfmt.emulatedSystems = [
      "armv7l-linux"
      "riscv64-linux"
      "riscv32-linux"
      "wasm32-wasi"
      "x86_64-windows"
    ];

    kernelPackages = pkgs.linuxPackages_zen;
    initrd = {
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      luks.devices."luks-e449e1a8-b71c-4f98-8c1b-8d8337af1180".device = "/dev/disk/by-uuid/e449e1a8-b71c-4f98-8c1b-8d8337af1180";
      luks.devices."luks-e449e1a8-b71c-4f98-8c1b-8d8337af1180".keyFile = "/crypto_keyfile.bin";
    };
  };
}