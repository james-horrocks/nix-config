{ config, pkgs, inputs, username, ... }:

{
  # Minimal nix-darwin configuration for a MacBook.
  # This file is a skeleton — adjust to taste and add darwin modules as needed.

  environment.systemPackages = with pkgs; [
    git
    zsh
    wget
    curl
    gh
    neovim
  ];

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    home = "/Users/${username}";
    shell = pkgs.zsh;
    extraGroups = [ "staff" ];
  };

  services.openssh.enable = true;

  # Appearance / energy: prefer dark mode (helps OLED) and reduce some wake behaviours
  environment.variables = {
    # hint for GUI apps
    FLAKE = "/Users/${username}/nix-config";
  };

  # Disable automatic login and screensaver dimming (user preference may vary)
  services.screensaver.enable = false;

  # Useful defaults for developers
  programs.zsh.enable = true;

  # Gatekeeper / security settings can be added with darwin.apple-signed or other modules

  # Placeholder for OLED monitor adjustments — external tools often needed
  # For example: add `monitorcontrol` or `ddcutil` as available and create a launchd service to set brightness.

  system.stateVersion = "22.11"; # adjust based on darwin modules compatibility
}
