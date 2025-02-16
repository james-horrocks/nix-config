{ inputs, config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      theme = "dracula";
      font-family = "MesloLGS NF";
      font-size = 14;

      cursor-style = "bar";
      cursor-style-blink = true;

      background-opacity = 0.85;
      background-blur = true;

      shell-integration = "zsh";
      shell-integration-features = true;
    };
  };
}