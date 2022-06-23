{ pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/22.05.tar.gz";
    sha256 = "0d643wp3l77hv2pmg2fi7vyxn4rwy0iyr8djcw1h5x72315ck9ik";
  }) {}
}:

let
  self = rec {
    r-shell = pkgs.mkShell {
      name = "r-shell";
      buildInputs = with pkgs; [
        pkgs.R
        pkgs.rPackages.tidyverse
      ];
    };
  };
in
  self
