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
        efiSysMountPoint = "/boot";
      };
    };
    
    binfmt.emulatedSystems = [
      "armv7l-linux"
      "riscv64-linux"
      "wasm32-wasi"
    ];

    kernelPackages = pkgs.linuxPackages_zen;
    initrd = {
      # luks.devices."luks-e449e1a8-b71c-4f98-8c1b-8d8337af1180".device = "/dev/disk/by-uuid/e449e1a8-b71c-4f98-8c1b-8d8337af1180";
      # luks.devices."luks-e449e1a8-b71c-4f98-8c1b-8d8337af1180".keyFile = "/crypto_keyfile.bin";
    };
  };
}
