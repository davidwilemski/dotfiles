{ lib, pkgs, ... }:

{
  enable = true;
  config = {
    # Default: # menu = "\${pkgs.dmenu}/bin/dmenu_run";
    menu = "i3-dmenu-desktop";
    #modifier = "Mod1";
    # TODO font (pango:monospace 8 on arch)
    # TODO something about xss-lock on i3lock
    
    #floating_modifier = "Mod1";

    terminal = "alacritty";
    bars = [
      {
        command = "${pkgs.i3}/bin/i3bar";
        position = "bottom";
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
      }
    ];
  };

  extraConfig = ''
    set $mod Mod1

    # kill focused window
    #bindsym $mod+Shift+q kill

    # change focus
    bindsym $mod+j focus left
    bindsym $mod+k focus down
    bindsym $mod+l focus up
    bindsym $mod+semicolon focus right

    # dtw: test lock
    #bindsym Mod4+l exec i3lock # --image ~/wallpaper/rivendel.png
    bindsym Mod4+l exec ${pkgs.i3lock-fancy}/bin/i3lock-fancy

    # move focused window
    bindsym $mod+Shift+j move left
    bindsym $mod+Shift+k move down
    bindsym $mod+Shift+l move up
    bindsym $mod+Shift+semicolon move right
    
    # split in horizontal orientation
    #bindsym $mod+h split h
    
    # split in vertical orientation
    #bindsym $mod+v split v
    
    # enter fullscreen mode for the focused container
    #bindsym $mod+f fullscreen toggle
    
    # change container layout (stacked, tabbed, toggle split)
    #bindsym $mod+s layout stacking
    #bindsym $mod+w layout tabbed
    #bindsym $mod+e layout toggle split
    
    # toggle tiling / floating
    # bindsym $mod+Shift+space floating toggle
    
    # change focus between tiling / floating windows
    #bindsym $mod+space focus mode_toggle
    
    # focus the parent container
    #bindsym $mod+a focus parent
    
    # screenshot
    #bindsym $mod+Control+Shift+4 exec "flameshot gui"
    
    # focus the child container
    #bindsym $mod+d focus child
  '';
}
