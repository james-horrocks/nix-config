{ inputs, config, pkgs, username, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # colorScheme = inputs.nix-colors.colorSchemes.dracula;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    nixpkgs-fmt

    # alacritty
    inputs.ghostty.packages.x86_64-linux.default
    meslo-lgs-nf
    zsh-powerlevel10k
    zsh-fast-syntax-highlighting

    coreutils
    file
    fzf
    gnumake
    wget
    _1password-cli
    _1password-gui
    polkit_gnome
    dracula-theme
    dracula-icon-theme
    fastfetch
    btop
    nvtopPackages.intel

    firefox
    spotify-player
    protonvpn-gui
    planify
    obsidian
    beeper

    vscode
    jetbrains.pycharm-professional
    ollama
    uv
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".dircolors".source = ./home_manager/dracula_dircolors;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/james/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "code";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.nh = {
  #   enable = true;
  #   flake = "/home/james/nix-config";
  # };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     package = pkgs.dracula-theme;
  #     name = "Dracula";
  #   };

  #   iconTheme = {
  #     package = pkgs.dracula-icon-theme;
  #     name = "Dracula";
  #   };
  # };

  qt = {
    enable = false;
    platformTheme.name = "gtk";
  };

  programs.rofi = {
    enable = true;
    location = "center";
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.dracula-icon-theme;
      name = "Dracula";
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.git = {
    enable = true;
    userName = "James Horrocks";
    userEmail = "jphorrocks@proton.me";
    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACCeXcAMW7DTQ5M9j95T0Yi6OgKOYHbJZ/O8f7Lx9xJ";
      signByDefault = true;
      signer = "/run/current-system/sw/bin/op-ssh-sign";
    };
    ignores = [
      ".vscode/"
      ".idea/"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
      gpg.ssh.program = "/run/current-system/sw/bin/op-ssh-sign";
    };
  };

  # programs._1password-shell-plugins = {
  #   # enable 1Password shell plugins for bash, zsh, and fish shell
  #   enable = true;
  #   # the specified packages as well as 1Password CLI will be
  #   # automatically installed and configured to use shell plugins
  #   plugins = with pkgs; [ gh awscli2 ];
  # };

  imports = [
    # inputs.nix-colors.homeManagerModules.default
    # ./home_manager/hyprland.nix
    # ./home_manager/waybar.nix
    # ./home_manager/rofi.nix
    # inputs._1password-shell-plugins.hmModules.default
    ./home_manager/zsh.nix
    ./home_manager/alacritty.nix
    ./home_manager/ghostty.nix
  ];
}
