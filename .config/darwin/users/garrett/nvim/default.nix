# Customized Neovim with plugins, config, etc.
# https://nixos.org/manual/nixpkgs/unstable/#managing-plugins-with-vim-packages

{ pkgs }:

pkgs.neovim.override {
  configure = {
    # TODO: move init.vim into this directory
    customRC = builtins.readFile ../init.vim;
    packages.myPlugins = {
      start = (import ./plugins.nix { inherit pkgs; });
      # If a Vim plugin has a dependency that is not explicitly listed in
      # opt that dependency will always be added to start to avoid
      # confusion. Manually loadable by calling `:packadd $plugin-name`.
      # However, if a Vim plugin has a dependency that is not explicitly
      # listed in opt, that dependency will always be added to start to
      # avoid confusion.
      opt = [ ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
    };
  };
}
