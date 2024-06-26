{ inputs, config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    systemd.enable = true;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
    settings = {
      env = [
        "HYPRCURSOR_THEME,hyprcursor_Dracula"
        "HYPRCURSOR_SIZE,24"
      ];
      exec-once = [
        "hyprpaper"
        "hypridle"
        "1password"
      ];
      input.kb_layout = "gb";
      "$mod" = "SUPER";
      source = [
        "~/.config/hypr/monitors.conf"
        "~/.config/hypr/workspaces.conf"
      ];
      bind =
        [
          "$mod, B, exec, brave"
          ", Print, exec, grimblast copy area"
          "$mod, Return, exec, alacritty"
          "$mod, Q, killactive"
          "ALT, Tab, cyclenext"
          "ALT, Tab, bringactivetotop"
          "$mod, ESC, exec, hyprlock"
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 0, movetoworkspace, 10"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList
            (
              x:
              [
                "$mod, ${toString (x + 1)}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${toString (x + 1)}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            9)
        );
      bindr = [
        "$mod, SUPER_L, exec, rofi -show run"
        "$mod, Tab, workspace, e+1"
      ];
      bindm = [
        # mouse movements
        "$mod, mouse:272, moveWindow"
        "$mod, mouse:273, resizeWindow"
        "$mod ALT, mouse:272, resizeWindow"
      ];

      animation = [
        "global, 1, 3, default"
      ];

      plugin = {
        hyprbars = {
          # example config
          bar_height = 20;

          # example buttons (R -> L)
          # hyprbars-button = color, size, on-click
          hyprbars-button = [
            "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive"
            "rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
          ];
        };
      };
    };
  };

  home.file = {
    ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;

    ".config/hypr/hypridle.conf".source = ./hypridle.conf;

    ".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
    ".config/hypr/mocha.conf".source = ./mocha.conf;
    ".config/face.png".source = ./face.png;

    ".local/share/icons/hyprcursor_Dracula".source = ./hyprcursor_Dracula;
  };
}
