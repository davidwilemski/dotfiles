# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix

      ../../common
    ];

  dtw.desktop.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_5_15;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    # This was the default nixos-config
    # "nixos-config=/etc/nixos/configuration.nix"
    "nixos-config=/home/dtw/dotfiles/nix/hosts/faolin/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  networking.hostName = "faolin"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno2.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    xkbOptions = "caps:escape";

    videoDrivers = [ "nvidia" ];
    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option "AllowIndirectGLXProtocol" "off"
      Option "TripleBuffer" "on"
    '';
    
    # Configure keymap in X11
    layout = "us";

    desktopManager = {
      # Delegate xsession to home-manager
      # See https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/8
      session = [
        {
          name = "i3";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];
      # remove if the above delegation works
      # xterm.enable = false;
    };

    # See nixos.wiki/wiki/I3
    # recommends displayManager.defaultSession = "none+i3"
    displayManager.defaultSession = "none+i3";
    displayManager.lightdm.enable = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        #i3status
        i3status-rust
        i3lock
      ];
    };
  };

  # From https://github.com/Mic92/dotfiles/blob/c9971df4e35ce104a77b1c100ba1b51c3367d5fa/nixos/modules/xss-lock.nix
  programs.xss-lock.enable = true;
  programs.xss-lock.lockerCommand = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";

  systemd.user.services.xss-lock.serviceConfig = {
    ExecStartPre = "${pkgs.xlibs.xset}/bin/xset s 300 300";
  };

  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dtw = {
    isNormalUser = true;
    initialPassword = "wtd";
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };
 
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    neovim
    pciutils
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.tailscale.enable = true;
  # TODO - re-enable (though doesn't matter that much, this machine is not exposed externally)
  # disabled because connecting to node exporter over tailscale was not working
  networking.firewall.enable = false;
  networking.firewall = {
    allowedUDPPorts = [ 41641 ];
  };


  # manpage says enabling does the firewall port config stuff
  programs.mosh.enable = true;
  # from https://github.com/Mic92/dotfiles/blob/master/nixos/modules/mosh.nix
  #networking.firewall.allowedUDPPortRanges = lib.optionals (config.services.openssh.enable) [
  #  # Mosh
  #  { from = 60000; to = 60010; }
  #];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  fonts.fonts = [
    pkgs.font-awesome
    pkgs.font-awesome_4
    pkgs.font-awesome-ttf
  ];

  virtualisation.docker.enable = true;
}

