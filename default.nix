{ pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz";
    sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
  }) {}
}:

let
  pythonPackages = pkgs.python3Packages;

  packages = rec {
    website = pkgs.stdenv.mkDerivation rec {
      name = "website-mpoquet";

      src = ./.;
      buildInputs = [
        pythonPackages.sphinx
        pygments-csv-lexer
        pkgs.gnumake
      ];

      buildPhase = "rm -rf build ; make html";
      installPhase = ''
        mkdir -p $out
        cp -r build/html/* $out/
      '';
    };
    pygments-csv-lexer = pythonPackages.buildPythonApplication rec {
      pname = "pygments-csv-lexer";
      version = "0.1.3";

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "sha256-PzDtgQ7AoHH79maOXIpSgk77Sa+JZmwflgKDcWPzJA8=";
      };

      propagatedBuildInputs = [
        pythonPackages.pygments
      ];

      doCheck = false;
    };
  };
in
  packages.website
