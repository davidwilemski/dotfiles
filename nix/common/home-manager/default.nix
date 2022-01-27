{ ... }:

{
  imports = [
  ];

  nixpkgs.config = {
    allowUnfree = true;

    manual.manpages.enable = true;
  };

  systemd.user.startServices = true;

}
