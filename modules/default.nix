{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./boot.nix
    ./fonts.nix
    ./locale.nix
    ./networking.nix
    ./services.nix
    ./virt.nix
  ];
}
