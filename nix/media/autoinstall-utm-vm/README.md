Based almost completely on https://github.com/Xe/nixos-configs/tree/0bf2ebdfc6ad9e43f07646d238070074d2890ba0/media/autoinstall-alrest

```
nix-shell -p nixos-generators
nixos-generate -f install-iso -c ./iso.nix
```
