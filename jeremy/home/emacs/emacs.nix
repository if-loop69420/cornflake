config: pkgs:


let 
  epkgs = pkgs.emacsPackages;
in {
  enable = true;
  package = pkgs.emacs;
  extraPackages = epkgs: with epkgs; [ 
    magit 
    evil 
    doom-themes 
    helm 
    ivy
    command-log-mode
    swiper
    doom-modeline
    which-key
    ivy-rich
    counsel
    all-the-icons
    projectile
		general
  ];

  extraConfig = (builtins.readFile ./init.el);
}
