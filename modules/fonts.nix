
{
  config,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
    mononoki
    font-awesome_6
    arkpandora_ttf
    liberation_ttf
    # nerd-fonts.hack
    # nerd-fonts.roboto-mono
    # nerd-fonts.jetbrains-mono
    # nerd-fonts.sauce-code-pro
    nerdfonts
  ];
}
