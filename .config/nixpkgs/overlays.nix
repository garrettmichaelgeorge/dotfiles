[
  # https://github.com/nix-community/neovim-nightly-overlay
  (self: super: {
    inherit (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }));
  })

  # https://nixos.org/manual/nixpkgs/unstable/#installing-environments-globally-on-the-system
  (self: super: {
    myEnv = super.buildEnv {
      name = "myPython";
      paths = [
        # A Python 3 interpreter with some packages
        (self.python3.withPackages (
          ps: with ps; [
            pynvim
          ]
        ))

        # Some other packages we'd like as part of this env
      ];
    };
  })
]
