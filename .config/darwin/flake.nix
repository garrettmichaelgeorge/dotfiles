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
      name = "garrettvery-mbp-2019";
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake ./modules/examples#simple \
      #       --override-input darwin .
      darwinConfigurations = {
        "${name}" = darwin.lib.darwinSystem {
          pkgs = import nixpkgs {
            system = "x86_64-darwin";
            config = { allowUnfree = true; };
            overlays = [ ];
          };
          specialArgs = {
            trustedUsers = [ userName ];
          };
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.garrett.imports = [ ./home.nix ];
              };
            }
          ];
          system = "x86_64-darwin";
        };
      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."${name}".pkgs;
    };
}
