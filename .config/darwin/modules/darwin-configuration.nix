# See https://github.com/LnL7/nix-darwin/blob/master/modules/examples/lnl.nix

{ config, pkgs, specialArgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs;
    [
      bashInteractive
      neovim
      vim
      zsh
    ];

  environment.variables = {
    THIS_WAS_SET_FROM_DARWIN_CONFIGURATION = "verily!";
  };

  # Facilitate bash completion for system packages
  # https://nix-community.github.io/home-manager/options.html#opt-programs.bash.enableCompletion
  environment.pathsToLink = [ "/share/bash-completion" ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      cores = 0;
      max-jobs = "auto";
      substituters = [ ];
      trusted-public-keys = [ ];
      trusted-users = [ "root" ] ++ specialArgs.trustedUsers;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    dock.autohide = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 1;
  };
}
