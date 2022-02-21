{ lib, python3Packages, fetchFromGitHub, dictdiffer }:
# with import <nixpkgs> { };
# with python3Packages;

python3Packages.buildPythonApplication rec {
  pname = "csv-diff";
  version = "1.1";

  /* src = builtins.fetchurl { */
  /*   url  = "https://files.pythonhosted.org/packages/bb/cf/53d23ae469f2727a5bdb7d6442573084136d2d713129e420cb554ff5506c/csv_diff-1.1-py3-none-any.whl"; */
  /*   sha256 = "sha256:1vz0gkf57c4pikkp2d1fjgzh498nhhc0ic2bw154np0nd7xlf57l"; */
  /* }; */

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "sha256-gKdVyW5LYAGfpnComGi93atHoHGYu95QchKklYLsBe0=";
  };

  # We shouldn't need pytest-runner to build or install the package given that
  # we are using pytestCheckHook
  postPatch = ''
    sed -e "/pytest-runner/d" -i setup.py
  '';

  
  propagatedBuildInputs = with python3Packages; [
    click
    dictdiffer
  ];

  checkInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = with lib; {
    description = "Python CLI tool and library for diffing CSV and JSON files";
    homepage = "https://github.com/simonw/csv-diff";
    license = licenses.asl20;
  };
}
