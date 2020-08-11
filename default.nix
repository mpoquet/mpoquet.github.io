{ pkgs ? import (
    fetchTarball "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz") {}
}:

let
  pythonPackages = pkgs.python37Packages;

  packages = rec {
    website = pkgs.stdenv.mkDerivation rec {
      name = "website-mpoquet";

      src = ./.;
      buildInputs = [
        pythonPackages.sphinx
        pkgs.gnumake
      ];

      buildPhase = "rm -rf build ; make html";
      installPhase = ''
        mkdir -p $out
        cp -r build/html/* $out/
      '';
    };
  };
in
  packages.website
