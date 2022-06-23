{ pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz";
    sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
  }) {}
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
