# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 60;
  };

  boot.kernelParams = [ "libata.force=1:disable,2:disable,3:disable"];

  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b7f5030f-46d3-408b-80a8-bbc96352fbdd";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-ef1b578b-1bf4-467c-a1c6-f2acbd2ebfe4".device = "/dev/disk/by-uuid/ef1b578b-1bf4-467c-a1c6-f2acbd2ebfe4";

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/1E1A-0151";
      fsType = "vfat";
    };
    
  fileSystems."/mnt/sda2" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
  
  # Hardware options 
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.forceFullCompositionPipeline = true;
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:0:1:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.pulseaudio.enable = false;

  hardware.bluetooth = {
      enable = true;
  };
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
