# Facilitate running darwin-rebuild as a flake app, e.g.
# nix run reference-to-this-flake
# https://github.com/LnL7/nix-darwin/issues/613#issuecomment-1485325805

{ pkgs
, self
, system
, darwin
, machineName
  # Use passthru argument by default
, builderCommand ? "$@"
}:

let
  emptyConfiguration = darwin.lib.darwinSystem {
    inherit system;
    modules = [ ];
  };

  builder =
    if pkgs.stdenv.isDarwin
    then "${emptyConfiguration.system}/sw/bin/darwin-rebuild"
    else pkgs.lib.getExe pkgs.nixos-rebuid;
in
pkgs.writeScript "activate-system" ''
  set -eux

  # TODO: make this configurable to allow for different configurations for
  # different machines
  # hostname=$(hostname -s)

  # Preflight
  # Determine flake location (in GitHub Actions, it seems to be in a different
  # place?)
  if [[ -e "${self}/flake.nix" ]]; then
    flake_ref="${self}"
  elif [[ -e "${self}/.config/darwin/flake.nix" ]]; then
    flake_ref="${self}/.config/darwin"
  else
    echo "Failed to find a valid flake reference" >&2
    exit 1
  fi

  ${builder} --flake "$flake_ref#${machineName}" ${builderCommand}
''
