{buildGoPackage, fetchFromGitHub}:

buildGoPackage rec {
  pname = "llama";
  version = "531680416adb9a67c66bcd80e31557c8ef7fcfef";

  goPackagePath = "github.com/nelhage/llama";

  src = fetchFromGitHub {
    owner = "nelhage";
    repo = "llama";
    rev = "${version}";
    sha256 = "sha256-H9iEpINO1VwXUuH8b1uu/zk0mbwf8gJ2nG/lKU1rCag=";
  };

  goDeps = ./deps.nix;
}
