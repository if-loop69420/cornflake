
{
  config,
  pkgs,
  ...
}: {
  fonts.fonts = with pkgs; [
    nerdfonts
    source-code-pro
    font-awesome
    mononoki
    ubuntu_font_family
    font-awesome_6
  ];
}