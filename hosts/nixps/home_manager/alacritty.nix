{ inputs, config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "full";
        opacity = 0.85;
      };

      cursor = {
        style = "Beam";
      };

      keyboard = {
        bindings = [
          {
            action = "Paste";
            key = "V";
            mods = "Control|Shift";
          }
          {
            action = "Copy";
            key = "C";
            mods = "Control|Shift";
          }
        ];
      };

      font = {
        normal = {
          family = "MesloLGS NF";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS NF";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS NF";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGS NF";
          style = "Bold Italic";
        };
      };

      colors = {
        primary = {
          background = "#202734";
          foreground = "#CBCCC6";
        };
        normal = {
          black = "#191E2A";
          blue = "#73D0FF";
          cyan = "#95E6CB";
          green = "#BAE67E";
          magenta = "#FFD580";
          red = "#FF3333";
          white = "#C7C7C7";
          yellow = "#FFA759";
        };
        bright = {
          black = "#686868";
          blue = "#5CCFE6";
          cyan = "#95E6CB";
          green = "#A6CC70";
          magenta = "#FFEE99";
          red = "#F27983";
          white = "#FFFFFF";
          yellow = "#FFCC66";
        };
      };
    };
  };

}