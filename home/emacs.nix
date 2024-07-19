config: pkgs:

let 
  epkgs = pkgs.emacsPackages;
in {
  enable = true;
  package = package.emacs;
  extraConfig = ''
    
  '';
}
