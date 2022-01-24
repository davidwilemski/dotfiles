with (import <nixpkgs> {});

mkShell {
  buildInputs = [
    morph
  ];
}
