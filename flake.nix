{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    # Run unpatched dynamic binaries
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # cosmic-manager = {
    #   url = "github:HeitorAugustoLN/cosmic-manager";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     home-manager.follows = "home-manager";
    #   };
    # };

    nix-colors.url = "github:misterio77/nix-colors";

    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    _1password-shell-plugins.url = "github:1Password/shell-plugins";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = {
    self,
    nixpkgs,
    lix-module,
    nixos-hardware,
    nix-ld,
    nix-index-database,
    home-manager,
    # cosmic-manager,
    # hyprland,
    nixpkgs-python,
    nixos-cosmic,
    ghostty,
    ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      python = nixpkgs-python.packages.${system};
      username = "james";
    in
    {
      nixosConfigurations = {
        nixps = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            lix-module.nixosModules.default
            nixos-cosmic.nixosModules.default
            ./hosts/nixps/configuration.nix
            nixos-hardware.nixosModules.dell-xps-13-9300
            nix-ld.nixosModules.nix-ld
            nix-index-database.nixosModules.nix-index
            # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
            # to not collide with the nixpkgs version.
            { programs.nix-ld.dev.enable = true; }
            inputs.home-manager.nixosModules.default
          ];
          extraSpecialArgs = { username = username; };
        };
      };
      homeConfigurations = {
        nixps = home-manager.lib.homeManagerConfiguration {
          specialArgs = { inherit inputs; };
          pkgs = pkgs;
          modules = [
            ./hosts/nixps/home.nix
            # cosmic-manager.homeManagerModules.cosmic-manager
            # hyprland.homeManagerModules.default
            # {wayland.windowManager.hyprland.enable = true;}
          ];
          extraSpecialArgs = { username = username; };
        };
        wsl = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            ./hosts/wsl/home.nix
          ];
          extraSpecialArgs = { username = username; };
        };
      };
    };
}
