{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/20.09.tar.gz") {}
}:

rec {
  pythonPackages = pkgs.python3Packages;
  buildPythonPackage = pythonPackages.buildPythonPackage;

  pdfcropmargins = buildPythonPackage {
    name = "pdfcropmargins-1.0.5";
    propagatedBuildInputs = [
      pythonPackages.setuptools_scm
      pythonPackages.pypdf2
      pythonPackages.pillow
    ];
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/7f/f1/cfa4875dd77fb0d0a992c8579264ba75b665393d9a58533bb2231ae9f368/pdfCropMargins-1.0.5.tar.gz";
      sha256 = "76fd16b3955e11b2a9fc3ad839342d6528f10324908a4a8f04f94ecda68205b3";
    };
  };
}
