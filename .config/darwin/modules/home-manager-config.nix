{ home-manager, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.garrett = import ../users/garrett;
  };
}
