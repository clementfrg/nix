{ lib
, config
, pkgs
, default
, ...
}:
let
  mainMod = ''$mainMod = SUPER'';
  applicationsShortcuts =
    let
      term = "${pkgs.kitty}/bin/kitty";
      dmenu = "${pkgs.rofi}/bin/rofi -modi drun -show drun -show-icons";
      betterlockscreen = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
      screenshot = "${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
      light = "${pkgs.light}/bin/light";
      alsa = "${pkgs.alsa-utils}/bin/amixer -q sset Master";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
    in
    ''
      bind = $mainMod, Return, exec, ${term}
      bind = $mainMod, D, exec, ${dmenu}
      bind = $mainMod, L, exec, ${betterlockscreen}
      bind = , PRINT, exec, ${screenshot}

      binde = , XF86MonBrightnessDown, exec, ${light} -U 5
      binde = , XF86MonBrightnessUp, exec, ${light} -A 5

      binde = , XF86AudioRaiseVolume, exec, ${alsa} 1%+
      binde = , XF86AudioLowerVolume, exec, ${alsa} 1%-
      bindl = , XF86AudioMute, exec, ${alsa} toggle

      bindl = , XF86AudioPlay, exec, ${playerctl} play-pause
      bindl = , XF86AudioPause, exec, ${playerctl} play-pause
      bindl = , XF86AudioNext, exec, ${playerctl} next
      bindl = , XF86AudioPrev, exec, ${playerctl} previous

    '';

  workspaceControl = ''
    # workspace


    workspace = 1, monitor:eDP-1, default:true
    #binds mainMod + [shift +] {1..10} to [move to] ws {1..10}
 
    bind = $mainMod SHIFT, right, movetoworkspace, +1
    bind = $mainMod SHIFT, left, movetoworkspace, -1
    bind = $mainMod SHIFT, mouse_down, movetoworkspace, +1
    bind = $mainMod SHIFT, mouse_up, movetoworkspace, -1

    bind = $mainMod CONTROL, right, workspace, +1
    bind = $mainMod CONTROL, left, workspace, -1
    bind = $mainMod, mouse_down, workspace, +1
    bind = $mainMod, mouse_up, workspace, -1
  '';

  compositorControls = ''
    bind = $mainMod SHIFT, Q, killactive
    bind = $mainMod SHIFT, E, exec, poweroff

    bind = $mainMod, F, fullscreen
    bind = $mainMod, Space, togglefloating

    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # move focus
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # move window
    binde = $mainMod SHIFT, left, movewindow, l
    binde = $mainMod SHIFT, right, movewindow, r
    binde = $mainMod SHIFT, up, movewindow, u
    binde = $mainMod SHIFT, down, movewindow, d
    # When floating
    binde = $mainMod SHIFT, left, moveactive, -30 0
    binde = $mainMod SHIFT, right, moveactive, 30 0
    binde = $mainMod SHIFT, up, moveactive, 0 -30
    binde = $mainMod SHIFT, down, moveactive, 0 30

    # window resize
    bind = $mainMod, R, submap, resize

    submap = resize
    binde = , right, resizeactive, 10 0
    binde = , left, resizeactive, -10 0
    binde = , up, resizeactive, 0 -10
    binde = , down, resizeactive, 0 10
    bind = , escape, submap, reset
    submap = reset
  '';

  gaps = ''
    general {
        gaps_in = 2
        gaps_out = 5
        layout = dwindle
        border_size = 3
        col.active_border = rgb(8be9fd) rgb(ff79c6) 45deg
        col.inactive_border = rgb(6272a4)
    }
  '';
  general =
    ''
      monitor=eDP-1, preferred, 5260x0, 0.8
      monitor=DP-2, preferred, 0x0, 1

      input {
        kb_layout = fr
        follow_mouse = 1 # Cursor movement will always change focus to the window under the cursor.
      }

      # make Firefox PiP window floating and sticky
      windowrulev2 = float,title:(Picture-in-Picture)
      windowrulev2 = pin,title:(Picture-in-Picture)
      windowrulev2 = size 20% 20%,title:(Picture-in-Picture)
      windowrulev2 = noborder,title:(Picture-in-Picture)


      # idle inhibit while watching videos
      windowrulev2 = idleinhibit focus, class:^(mpv|.+exe)$
      windowrulev2 = idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$
      windowrulev2 = idleinhibit fullscreen, class:^(firefox)$
    '';
  decoration = ''
    decoration {
      rounding = 5

      drop_shadow = yes
      shadow_range = 4
      shadow_render_power = 3
      col.shadow = rgba(1a1a1aee)

      active_opacity = 1.0
      inactive_opacity = 0.9

      blur {
        enabled = true
        size = 5
        passes = 1
        ignore_opacity = false
      }
    }
  '';
  animations = ''
      animations {
        enabled = yes

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }
  '';
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    env = WLR_NO_HARDWARE_CURSORS,1

    ${mainMod}
    ${workspaceControl}
    ${compositorControls}
    ${applicationsShortcuts}
    ${gaps}
    ${decoration}
    ${general}
    ${animations}
  '';
}
