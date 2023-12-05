
{
  config,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    nerdfonts
    source-code-pro
    font-awesome
    mononoki
    ubuntu_font_family
    font-awesome_6
    arkpandora_ttf
    liberation_ttf
  ];
}
