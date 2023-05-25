{ home-manager, config, specialArgs, ... }:

let
  user = specialArgs.user;
in
# https://nix-community.github.io/home-manager/nix-darwin-options.html
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    users."${user}" = import (../users + "/${user}");
  };

  # Defining the user again in nix-darwin, after already defining it for
  # home-manager, feels redundant. Nevertheless, without it, nix-darwin will
  # assume the home directory is `/var/empty`, which causes all kinds of
  # problems. 
  # https://github.com/LnL7/nix-darwin/issues/423
  # https://github.com/nix-community/home-manager/issues/2004
  users.users."${user}" = {
    name = "${user}";
    home = "/Users/${user}";
  };
}
