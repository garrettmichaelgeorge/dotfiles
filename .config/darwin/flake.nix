{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # FIXME: encountering neovim build errors on x86_64-darwin (why isn't it
    # using the nix-community Cachix substituter instead?)
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }:
    let
      userName = "garrett";
      system = "x86_64-darwin";

      # TODO: make this configurable to allow for different configurations for
      # different machines
      # machineName = "very-mbp-2019";
      machineName = system;

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
          specialArgs = { user = userName; trustedUsers = [ userName ]; };
          modules = [
            ./modules/darwin-configuration.nix
            ./modules/linux-builder
            home-manager.darwinModules.home-manager
            ./modules/home-manager-config.nix
          ];
        };

        # Same as above, but without Linux builder
        # FIXME: re-enable Linux builder and get it to work in CI
        # This is a temporary workaround to resolve an issue in CI.
        # It shouldn't be necessary to disable the Linux builder.
        # The Linux builder closure should, in theory, be entirely available
        # from cache.nixos.org and not require building. However, in the GitHub
        # Actions macOS runner, the following error was thrown when building and
        # applying this configuration:
        #
        # error: a 'x86_64-linux' with features {} is required to build
        # '/nix/store/9r8ym11py2s2j82fjdwkr7rv0dgaf8h5-boot.json.drv', but I am
        # a 'x86_64-darwin' with features {benchmark, big-parallel, nixos-test}
        "${machineName}-no-linux-builder" = darwin.lib.darwinSystem {
          inherit pkgs system;
          specialArgs = { user = userName; trustedUsers = [ userName ]; };
          modules = [
            ./modules/darwin-configuration.nix
            # ./modules/linux-builder
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
          rebuildSwitch = mkApp (systemAppString { inherit machineName; builderCommand = "switch"; });

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
