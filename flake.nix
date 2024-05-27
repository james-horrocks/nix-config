{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
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

    nix-colors.url = "github:misterio77/nix-colors";

    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    nix-ld,
    nix-index-database,
    home-manager,
    # hyprland,
    nixpkgs-python,
    ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      python = nixpkgs-python.packages.${system};
    in
    {
      nixosConfigurations = {
        nixps = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/nixps/configuration.nix
            nixos-hardware.nixosModules.dell-xps-13-9300
            nix-ld.nixosModules.nix-ld
            nix-index-database.nixosModules.nix-index
            # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
            # to not collide with the nixpkgs version.
            { programs.nix-ld.dev.enable = true; }
            inputs.home-manager.nixosModules.default
          ];
        };
        # TODO: Add config for work machine
      };
      homeConfigurations = {
        "james@nixps" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            ./hosts/nixps/home.nix
            # hyprland.homeManagerModules.default
            # {wayland.windowManager.hyprland.enable = true;}
          ];
        };
        # TODO: Add config for work machine
      };
    };
}
