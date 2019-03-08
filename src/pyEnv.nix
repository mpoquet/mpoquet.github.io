{
  pkgs ? import (
    fetchTarball "https://github.com/NixOS/nixpkgs/archive/18.03.tar.gz") {},
}:

pkgs.python36.withPackages (ps: [
  ps.docopt
])
