/* { lib */
/* , buildPythonPackage */
/* , fetchPypi */
/* }: */
{ buildPythonPackage
, fetchPypi
}:

# Use in not-function form
#with import <nixpkgs> { };
#with python3Packages;

buildPythonPackage {
  pname = "dictdiffer";
  version = "0.9.0";

  src = fetchPypi {
    pname = "dictdiffer";
    version = "0.9.0";
    sha256 = "sha256-F7rPX7/mE8zxttUSvXZuayH7eYgioTOqhgmLismZdXg=";
  };

  # checkInputs = [ pytestCheckHook ];
  #propagatedBuildInputs = [ tox ];
  doCheck = false;

  /* meta = with lib; { */
  /*   homepage = "https://github.com/inveniosoftware/dictdiffer"; */
  /*   description = "Dictdiffer is a helper module that helps you to diff and patch dictionaries."; */
  /*   license = licenses.mit; */
  /* }; */
}
