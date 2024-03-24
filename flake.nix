{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        personal_laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./configuration.nix
            nixos-hardware.nixosModules.dell-xps-13-9300
            inputs.home-manager.nixosModules.default
          ];
        };
        # TODO: Add config for work machine
      };
      homeConfigurations = {
        personal_laptop = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            hyprland.homeManagerModules.default
            {wayland.windowManager.hyprland.enable = true;}
            # ...
          ];
        };
        # TODO: Add config for work machine
      };
    };
}
