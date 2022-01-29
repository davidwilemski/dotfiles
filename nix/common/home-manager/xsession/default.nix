{ lib, pkgs, nixosConfig, ... }:

{

  config = lib.mkIf nixosConfig.dtw.desktop.enable {
    xsession.enable = true;
    xsession.scriptPath = ".hm-session"; # Ref: https://github.com/workflow/nixos-config/blob/2a9b597810ae6a26b6182c00206871387fcfd8c4/home/xsession/default.nix#L14
    xsession.pointerCursor = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 16;
    };
    xsession.windowManager.i3 = import ./i3.nix { inherit lib pkgs; };
  };
}
