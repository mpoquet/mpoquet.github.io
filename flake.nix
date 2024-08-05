{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pyPackages = pkgs.python3Packages;
      in rec {
        packages =  rec {
          pygments-csv-lexer = pyPackages.buildPythonApplication rec {
            pname = "pygments-csv-lexer";
            version = "0.1.3";
            src = pyPackages.fetchPypi {
              inherit pname version;
              sha256 = "sha256-PzDtgQ7AoHH79maOXIpSgk77Sa+JZmwflgKDcWPzJA8=";
            };
            propagatedBuildInputs = [
              pyPackages.pygments
            ];
            doCheck = false;
          };
          default = pkgs.stdenv.mkDerivation rec {
            name = "website-mpoquet";
            src = ./.;
            buildInputs = [
              pyPackages.sphinx
              pygments-csv-lexer
              pkgs.gnumake
            ];
            buildPhase = "make html";
            installPhase = ''
              mkdir -p $out
              cp -r build/html/* $out/
            '';
          };
        };
        devShells = {

        };
      }
    );
}
