# { lib, python3Packages, setuptools}:
with import <nixpkgs> { };
with python3Packages;

buildPythonApplication rec {
  dictdiffer = callPackage ../pythonPackages/dictdiffer { };

  pname = "csv-diff";
  version = "1.1";
  #format = "wheel";

  /* src = builtins.fetchurl { */
  /*   url  = "https://files.pythonhosted.org/packages/bb/cf/53d23ae469f2727a5bdb7d6442573084136d2d713129e420cb554ff5506c/csv_diff-1.1-py3-none-any.whl"; */
  /*   sha256 = "sha256:1vz0gkf57c4pikkp2d1fjgzh498nhhc0ic2bw154np0nd7xlf57l"; */
  /* }; */

  src = fetchPypi {
    inherit pname version;
    sha256 = "/5QReZLGfdi8T5FzdPTcGYlF/4Wx1noRvRSLY19Xa+o=";
  };

  #pipInstallFlags = [ "--ignore-installed" ];

  #propagatedBuildInputs = [ setuptools ];
  propagatedBuildInputs = with python3Packages; [ click dictdiffer ];

  meta = with lib; {
    description = "Python CLI tool and library for diffing CSV and JSON files";
    homepage = "https://github.com/simonw/csv-diff";
    license = licenses.asl20;
  };
}
