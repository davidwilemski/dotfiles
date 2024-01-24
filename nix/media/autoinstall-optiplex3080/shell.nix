with (import <nixpkgs> {});

mkShell {
  buildInputs = [
    nixos-generators
  ];
}
