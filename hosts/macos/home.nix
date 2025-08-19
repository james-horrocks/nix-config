{ inputs, config, pkgs, username, ... }:

{
  targets = { darwin = true; };
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    git
    zsh
    vscode
    nodejs
    go
    rustup
    openssh
    gh
    fastfetch
    ripgrep
    bat
    fd
    direnv
    neovim
    # fonts
    meslo-lgs-nf
  ];

  home.sessionVariables = {
    EDITOR = "code";
  };

  programs.home-manager.enable = true;

  imports = [
    ./home_manager/zsh.nix
  ];
}
