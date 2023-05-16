{ home-manager, ... }:

# https://nix-community.github.io/home-manager/nix-darwin-options.html
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    users.garrett = import ../users/garrett;
  };
}
