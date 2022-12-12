{ ... }:

{
  imports = [
    ./home-environment.nix
    ./shell.nix

    ./programs/neovim.nix

    ./desktop.nix
  ];

  # Basing structure of some of these imports on
  # github.com/workflow/nixos-config
  #
  # TODO - take over xsession management in home manager
  # See https://github.com/workflow/nixos-config/blob/2a9b597810ae6a26b6182c00206871387fcfd8c4/system/desktop.nix#L31
  # and https://github.com/workflow/nixos-config/blob/2a9b597810ae6a26b6182c00206871387fcfd8c4/home/xsession/default.nix

  # systemd.user.startServices = true;

}
