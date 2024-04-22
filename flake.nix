{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, hyprland, nixpkgs-python, ... }@inputs:
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
            inputs.home-manager.nixosModules.default
          ];
        };
        # TODO: Add config for work machine
      };
      homeConfigurations = {
        nixps = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            hyprland.homeManagerModules.default
            {wayland.windowManager.hyprland.enable = true;}
          ];
        };
        # TODO: Add config for work machine
      };
    };
}
