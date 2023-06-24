{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs, home-manager }:
    let
      userName = "garrett";

      machineNameWork = "garrettvery-mbp-2019";
      machineNamePersonal = "gg-mbp-2019";

      system = "x86_64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ ];
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake ./modules/examples#simple \
      #       --override-input darwin .
      darwinConfigurations = {
        "${machineNameWork}" = darwin.lib.darwinSystem {
          inherit pkgs system;
          specialArgs = { inherit self; trustedUsers = [ userName ]; };
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.garrett = import ./home.nix;
              };
            }
          ];
        };

        "${machineNamePersonal}" = darwin.lib.darwinSystem {
          inherit pkgs system;
          specialArgs = { inherit self; trustedUsers = [ userName ]; };
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.garrett = import ./home.nix;
              };
            }
          ];
        };
      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."${machineNamePersonal}".pkgs;

      # Facilitate running darwin-rebuild as a flake app, e.g.
      # nix run reference-to-this-flake
      # https://github.com/LnL7/nix-darwin/issues/613#issuecomment-1485325805
      apps."${system}".default =
        let
          emptyConfiguration = darwin.lib.darwinSystem {
            inherit system;
            modules = [ ];
          };

          builder =
            if pkgs.stdenv.isDarwin
            then "${emptyConfiguration.system}/sw/bin/darwin-rebuild switch"
            else pkgs.lib.getExe pkgs.nixos-rebuid;
        in
        {
          type = "app";

          program = toString (pkgs.writeScript "activate-system" ''
            set -eux
            ${builder} --flake "${self}/.config/darwin#''$(hostname -s)" "$@"
          '');
        };

      # For debugging purposes
      inherit self;
    };
}
