{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # FIXME: encountering neovim build errors on x86_64-darwin (why isn't it
    # using the nix-community Cachix substituter instead?)
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }:
    let
      userName = "garrett";
      machineName = "garrettvery-mbp-2019";
      system = "x86_64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        # FIXME: encountering neovim build errors on x86_64-darwin (why isn't it
        # using the nix-community Cachix substituter instead?)
        # overlays = [ neovim-nightly-overlay.overlay ];
      };
    in
    {
      darwinConfigurations = {
        "${machineName}" = darwin.lib.darwinSystem {
          inherit pkgs system;
          specialArgs = { trustedUsers = [ userName ]; };
          modules = [
            ./modules/darwin-configuration.nix
            ./modules/linux-builder
            home-manager.darwinModules.home-manager
            ./modules/home-manager-config.nix
          ];
        };
      };

      # Making the Darwin configuration system a package allows us to test it by
      # building it on its own with `nix build`, or verifying with
      # `nix flake check`.
      packages."${system}".default = self.darwinConfigurations."${machineName}".system;

      apps."${system}" =
        let
          systemApp = overrides: pkgs.callPackage ./apps/system
            ({ inherit pkgs self system darwin; } // overrides);

          systemAppString = overrides: toString (systemApp overrides);
          mkApp = program: { inherit program; type = "app"; };
        in
        rec {
          rebuild = mkApp (systemAppString { });
          rebuildSwitch = mkApp (systemAppString { builderCommand = "switch"; });

          # Facilitate running darwin-rebuild as a flake app, e.g. `nix run reference-to-this-flake`
          # https://github.com/LnL7/nix-darwin/issues/613#issuecomment-1485325805
          default = rebuildSwitch;
        };

      # For debugging in `nix repl`
      inherit self;

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."${machineName}".pkgs;
    };
}
