{ pkgs, lib, specialArgs, config, modulesPath, options, darwinConfig, osConfig }:

{
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "22.11";

  home.sessionVariables = {
    THIS_WAS_SET_BY_HOME_MANAGER = "yep!";
  };

  home.packages = with pkgs; [
    asdf-vm
    bat
    cachix
    coreutils
    curlie
    delta
    docker
    efm-langserver
    fd
    fzf
    gh
    git
    gzip
    htop
    httpie
    jq
    lsof
    lua-language-server
    mdcat
    nil
    nix-doc
    nmap
    nodePackages.bash-language-server
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
    vscode
    wget
    yarn
    zsh
  ];

  home.shellAliases = {
    c = "clear";
    e = "$EDITOR";
    v = "nvim";
    r = "ranger";
    g = "git";
    n = "nix";
    ka = "killall";
    ez = "exec zsh";
    psag = "ps aux | ag";
    myip = "curl ipinfo.io/ip";

    # Adding color
    ls = "ls -1a --color";
    grep = "grep --color=auto";
    ccat = "highlight --out-format=ansi"; # Color cat - print file with syntax highlighting.

    # Elixir
    imps = "iex - S mix phx.server";
    mdg = "mix deps.get";
    mps = "mix phx.server";
    mt = "mix test";
    mtc = "mix test --cover";
    mto = "mix test --only";
    mtw = ''
      fswatch - -latency=0.1 --one-per-batch -r lib test \
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
      # asdf version manager
      # . $HOME/.asdf/asdf.sh
      # append completions to fpath
      # fpath=("$ASDF_DIR/completions" $fpath)

      # initialise completions with ZSH's compinit
      # autoload -Uz compinit
      # compinit

      # iTerm2
      # test -e $HOME/.iterm2_shell_integration.zsh && source $HOME/.iterm2_shell_integration.zsh || true

      # one password (op)
      # source /Users/garrett/.config/op/plugins.sh
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
    extraConfig = builtins.readFile ./kitty/kitty.conf;
  };
}
