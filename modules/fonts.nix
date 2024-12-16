
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
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
