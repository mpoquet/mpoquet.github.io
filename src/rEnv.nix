{
  pkgs ? import (
    fetchTarball "https://github.com/NixOS/nixpkgs/archive/18.03.tar.gz") {},
}:

pkgs.rWrapper.override {
  packages = [
    pkgs.rPackages.tidyverse
    pkgs.rPackages.viridis
    pkgs.rPackages.rmarkdown
    pkgs.rPackages.docopt
  ];
}
