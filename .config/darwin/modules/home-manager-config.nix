{ home-manager, config, specialArgs, ... }:

let
  user = specialArgs.user;
  homeDirectory = "/Users/${user}";
in
# https://nix-community.github.io/home-manager/nix-darwin-options.html
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    backupFileExtension = "before-home-manager.bak";
    # TODO: find a more flexible design for user configuration
    # For now, all users will use the same config, declared in
    # users/garrett/default.nix
    # One idea:
    # users."${user}" = import (../users + "/${user}");
    users."${user}" = import (../users/garrett);
    extraSpecialArgs = { inherit homeDirectory; };
  };

  # Defining the user again in nix-darwin, after already defining it for
  # home-manager, feels redundant. Nevertheless, without it, nix-darwin will
  # assume the home directory is `/var/empty`, which causes all kinds of
  # problems. 
  # https://github.com/LnL7/nix-darwin/issues/423
  # https://github.com/nix-community/home-manager/issues/2004
  users.users."${user}" = {
    name = "${user}";
    home = homeDirectory;
  };
}
