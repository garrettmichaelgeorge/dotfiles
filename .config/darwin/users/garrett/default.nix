{ pkgs
, lib
, specialArgs
, config
, modulesPath
, options
, darwinConfig
, osConfig
, homeDirectory
}:

let
  # TODO: move these pkgs into top-level pkgs/ directory and add them as
  # overlays to nixpkgs
  fuzzyFindInFiles = pkgs.writeShellApplication {
    name = "fzfiles";
    runtimeInputs = with pkgs; [ fzf ripgrep bat neovim ];
    text = builtins.readFile ./fuzzy-find-in-files.sh;
  };

  fzfWork = pkgs.writeShellApplication {
    name = "work";
    runtimeInputs = with pkgs; [ fzf findutils ];
    text = ''
      FZF_DEFAULT_COMMAND="find $HOME/work -type d -maxdepth 1" \
        cd "$(fzf)"
    '';
  };

  browserShim = pkgs.writeShellApplication {
    name = "browser-shim";
    # TODO: consider specifying firefox as dependency
    runtimeInputs = [ ];
    text = builtins.readFile ./browser-shim.sh;
  };

  # HACK: this packages a set of legacy scripts with implicit dependencies
  # TODO: explicitly specify dependencies for each script
  localScripts =
    let
      mkBinPkg = name: _: (pkgs.writeScriptBin name
        (builtins.readFile (./bin + "/${name}"))
      );
    in
    pkgs.symlinkJoin {
      name = "local-scripts";
      paths = builtins.attrValues (builtins.mapAttrs mkBinPkg (builtins.readDir ./bin));
    };

  customNeovim = import ../../pkgs/nvim { inherit pkgs; };
in
{
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "22.11";

  home.homeDirectory = homeDirectory;

  home.sessionVariables = {
    THIS_WAS_SET_BY_HOME_MANAGER = "yep!";
    EDITOR = "nvim";
    BROWSER = "${browserShim}/bin/browser-shim";
  };

  home.packages = with pkgs; [
    asdf-vm
    browserShim
    cachix
    coreutils
    curlie
    customNeovim
    delta
    docker
    efm-langserver
    beam.packages.erlang.elixir-ls
    fd
    ffmpeg
    fuzzyFindInFiles
    fzf-git-sh
    gh
    git
    gzip
    htop
    httpie
    jq
    lsof
    localScripts
    lua-language-server
    mdcat
    nil
    nix-doc
    nmap
    nodePackages_latest.bash-language-server
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-langservers-extracted
    obsidian
    postgresql_14
    python310
    ranger
    ripgrep
    rnix-lsp
    ruby
    shellcheck
    silver-searcher
    sqlitebrowser
    srm
    starship
    terminal-notifier
    terraform-ls
    tflint
    tree
    universal-ctags
    wget
    yarn
    zsh
    fzfWork
  ];

  home.shellAliases = {
    c = "clear";
    e = "$EDITOR";
    v = "nvim";
    r = "ranger";
    g = "git";
    ka = "killall";
    ez = "exec zsh";
    psag = "ps aux | ag";
    myip = "curl ipinfo.io/ip";

    # Adding color
    ls = "ls -1a --color";
    grep = "grep --color=auto";
    ccat = "highlight --out-format=ansi"; # Color cat - print file with syntax highlighting.

    # Elixir
    imps = "iex -S mix phx.server";
    mdg = "mix deps.get";
    mps = "mix phx.server";
    mt = "mix test";
    mtc = "mix test --cover";
    mto = "mix test --only";
    mtw = ''
      fswatch --latency=0.1 --one-per-batch -r lib test \
      | mix test --warnings-as-errors --exclude not_implemented:true --listen-on-stdin
    '';

    # Terraform
    tf = "terraform";

    # Git dotfiles workflow
    # Read more: https://www.atlassian.com/git/tutorials/dotfiles
    config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";

    # Wine
    # Launch Steam on Wine
    steam_wine = "wine ~/.wine/drive_c/Program\ Files\ (x86)/Steam/steam.exe -no-cef-sandbox";

    # Nix
    n = "nix";
    nr = "nix run";
    nb = "nix build";
    nfc = "nix flake check";

    # Nix-Darwin
    # dr = "nix run ${specialArgs.self}";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    # TODO: figure out how to properly migrate these (they are commented for
    # now)
    initExtra = ''
      # one password (op)
      # source /Users/garrett/.config/op/plugins.sh

      source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
    '';

    envExtra = ''
      export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --info=inline --border --margin=1 --padding=1"
    '';
  };

  programs.bash = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      git_commit = {
        tag_disabled = false;
        only_detached = false;
      };
      shell.disabled = false;
    };
  };

  # https://github.com/justjanne/powerline-go
  programs.powerline-go = {
    enable = false;
    # https://github.com/justjanne/powerline-go#customization
    settings = {
      cwd-mode = "fancy";
      theme = "gruvbox";
    };
  };

  programs.kitty = {
    enable = true;
    theme = "Gruvbox Material Dark Medium";
    # font = {
    #   package = pkgs.fira-code;
    #   name = "Fira Code";
    #   size = "14.0";
    # };
    # settings = { };
    extraConfig = builtins.readFile ./kitty.conf;
  };

  # See programs.zsh.envExtra for env variables
  programs.fzf = {
    enable = true;
    package = pkgs.fzf;
    enableBashIntegration = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden --follow --glob '!.git'";
    # defaultOptions = [
    #   "--height=40%"
    #   "--layout=reverse"
    #   "--info=inline"
    #   "--border"
    #   "--margin=1"
    #   "--padding=1"
    # ];
  };

  # programs.neovim = {
  #   enable = true;
  # viAlias = true;
  # vimAlias = true;
  # vimdiffAlias = true;
  # extraConfig = builtins.readFile ./init.vim;
  # plugins = import ./nvim/plugins.nix { inherit pkgs; };
  # };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.bat = {
    enable = true;
    # Run `bat --help` to get a list of configuration options. Note these use
    # command-line syntax and will need to be translated into Nix equivalents.
    config = {
      italic-text = "always";
    };
  };

  manual.html.enable = true;
  manual.manpages.enable = true;
}
