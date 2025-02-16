# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand"; # will be managed by tlp
  powerManagement.powerUpCommands = ''
    echo XHC > /proc/acpi/wakeup
  '';

  networking.hostName = "nixps"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # substituters = [ "https://hyprland.cachix.org" ];
      # trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services = {
    fwupd.enable = true;
  };

  # # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm = {
  #   enable = true;
  #   wayland = true;
  # };
  # services.xserver.desktopManager.gnome.enable = true;

  # Enable the Cosmic Desktop Environment.
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  security.polkit.enable = true;

  xdg.portal.enable = true;
  # Not needed for GNOME
  # xdg.portal.extraPortals = [
  #   pkgs.xdg-desktop-portal
  #   pkgs.xdg-desktop-portal-gtk
  # ];

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "gb";
      variant = "";
    };
  };

  # Enable Hyprland
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  #   package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  # };

  environment.sessionVariables = {
    # If the cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    FLAKE = "/home/james/nix-config";
  };

  hardware.graphics.enable = true;
  hardware.system76.enableAll = true;

  # Enable zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "/etc/wireplumber/main.lua.d/50-alsa-config.lua" ''
          alsa_monitor.rules = {
            {
              matches = {
                {
                  -- Matches all sources.
                  { "node.name", "matches", "alsa_input.*" },
                },
                {
                  -- Matches all sinks.
                  { "node.name", "matches", "alsa_output.*" },
                },
              },
              apply_properties = {
                ["session.suspend-timeout-seconds"] = 0
              },
            },
          }
        '')
      ];
    };

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment.shells = with pkgs; [ zsh ];
  users.users.james = {
    isNormalUser = true;
    description = "James Horrocks";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  programs.command-not-found.enable = false;
  # for home-manager, use programs.bash.initExtra instead
  programs.zsh.interactiveShellInit = ''
    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  '';
  environment.pathsToLink = [ "/share/zsh" ];

  # home-manager = {
  #   # also pass inputs to home-manager modules
  #   extraSpecialArgs = {inherit inputs;};
  #   # users = {
  #   #   "james" = import ./home.nix;
  #   # };
  #   backupFileExtension = "bak";
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.libraries = with pkgs; [
    libgcc
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # Nix
    nixpkgs-fmt
    nh
    manix

    intel-media-driver
    intel-vaapi-driver

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
    most
    btop
    nvtopPackages.intel

    spotify-player
    protonvpn-gui
    vscode
    alacritty
    planify
    obsidian
    inputs.ghostty.packages.x86_64-linux.default

    ollama
    uv
  ];

  services.gnome = {
    gnome-keyring.enable = true;
    core-utilities.enable = true;
  };

  security = {
    pam = {
      services = {
        login.enableGnomeKeyring = true;
        "1password".enableGnomeKeyring = true;
      };
    };
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "james" ];
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowHybridSleep=yes
      AllowSuspendThenHibernate=yes
    '';
  };

  # Enable SSD trimming
  services.fstrim.enable = true;

  # Enable requirement for Samba
  services.gvfs.enable = true;

  # Auto upgrade
  # system.autoUpgrade.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?

}
