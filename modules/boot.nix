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
        # efiSysMountPoint = "/boot/efi";
      };
    };

    kernel.sysctl = {
      "apparmor"= 1;
      "debugfs" = "off";
      "dev.tty.ldisc_autoload" = 0;
      "fs.protected_fifos"=2;
      "fs.protected_hardlinks"=1;
      "fs.protected_regular"=2;
      "fs.protected_symlinks"=1;
      "init_on_alloc" = 1;
      "init_on_free" = 1;
      "kernel.dmesg_restrict" = 1;
      "kernel.kexec_load_disabled" = 1;
      "kernel.kptr_restrict" = 2;
      "kernel.perf_event_paranoid" = 3;
      "kernel.printk" = "3 3 3 3";
      "kernel.sysrq" = 4;
      "kernel.unprivileged_bpf_disabled" = 1;
      "kernel.unprivileged_userns_clone" = 1;
      "kernel.yama.ptrace_scope"=2;
      "lockdown" = "confidentiality";
      "module.sig_enforce" = 1;
      "net.core.bpf_jit_harden" = 2;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route"=0;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_source_route"=0;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.icmp_echo_ignore_all" = 1;
      "net.ipv4.tcp_dsack"=0;
      "net.ipv4.tcp_fack"=0;
      "net.ipv4.tcp_ref1337" = 1;
      "net.ipv4.tcp_sack"=0;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv6.conf.all.accept_ra"=0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.all.accept_source_route"=0;
      "net.ipv6.conf.default.accept_ra"=0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_source_route"=0;
      "oops" = "panic";
      "page_alloc.shuffle"= 1;
      "pti" = "on";
      "quiet loglevel" = 0;
      "security" = "apparmor";
      "slab_nomerge" = "";
      "vm.mmap_rnd_bits"=32;
      "vm.mmap_rnd_compat_bits"=16;
      "vm.swappiness" = 20;
      "vm.unprivileged_userfaultfd" = 0;
      "vsyscall" = "none";
    };
    
    binfmt.emulatedSystems = [
      "armv7l-linux"
      "riscv64-linux"
      "wasm32-wasi"
    ];

    kernelPackages = pkgs.linuxPackages_zen;
    # let
    #   custom_linux_pkg = {fetchurl, buildLinux, ...} @ args:
    #     buildLinux (args // rec {
    #       version = "6.10.2-zen1";
    #       modDirVersion = version;
    #       src = fetchurl {
    #         url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.10.2.tar.xz";
    #         hash = "sha256-c9hSDdnLpaz8XnII52s12XQLiq44IQqSJOMuxMDSm3A=";
    #       };
    #       kernelPatches = [
    #         {
    #           name = "zen";
    #           patch = ./linux-v6.10.2-zen1.patch;
    #         }
    #       ];
    #       extraStructuredConfig = (builtins.readFile ./kernel_conf);
    #       extraMeta.branch = "6.10";
    #     } // (args.argsOverrice or {}));
    #   custom_linux = pkgs.callPackage custom_linux_pkg{};
    # in 
      # pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor custom_linux);
    # initrd = {
    #   secrets = {
    #     "/crypto_keyfile.bin" = null;
    #   };
    # };
  };
}
