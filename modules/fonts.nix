
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
    font-awesome_6
    arkpandora_ttf
    liberation_ttf
  ];
}
