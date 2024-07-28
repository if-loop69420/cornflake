{
  config,
  pkgs,
  ...
}: {
  boot = {
    # kernelPatches = [
    #   {
    #     name = "Kernel_Customization";
    #     patch = null;
    #     # extraConfig = (builtins.readFile ./.config);
    #   }
    # ];
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    
    binfmt.emulatedSystems = [
      "armv7l-linux"
      "riscv64-linux"
      "wasm32-wasi"
    ];

    kernelPackages = 
    let
      custom_linux_pkg = {fetchurl, buildLinux, ...} @ args:
        buildLinux (args // rec {
          version = "6.10.2";
          modDirVersion = version;
          src = fetchurl {
            url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.10.2.tar.xz";
            hash = "sha256-c9hSDdnLpaz8XnII52s12XQLiq44IQqSJOMuxMDSm3A=";
          };
          kernelPatches = [];
          extraStructuredConfig = (builtins.readFile ./.config);
          extraMeta.branch = "6.10";
        } // (args.argsOverrice or {}));
      custom_linux = pkgs.callPackage custom_linux_pkg{};
    in 
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor custom_linux);
    initrd = {
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      # luks.devices."luks-e449e1a8-b71c-4f98-8c1b-8d8337af1180".device = "/dev/disk/by-uuid/e449e1a8-b71c-4f98-8c1b-8d8337af1180";
      # luks.devices."luks-e449e1a8-b71c-4f98-8c1b-8d8337af1180".keyFile = "/crypto_keyfile.bin";
    };
  };
}
