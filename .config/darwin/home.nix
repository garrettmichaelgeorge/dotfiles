{ pkgs, lib, specialArgs, config, modulesPath, options, darwinConfig, osConfig }:

{
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "22.11";

  home.sessionVariables = {
    THIS_WAS_SET_IN_NIX_DARWIN = "yep!";
  };

  home.packages = with pkgs; [
    asdf-vm
    bash
    bat
    cachix
    coreutils
    curlie
    delta
    direnv
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
    nix-direnv
    nix-doc
    nmap
    nodePackages.bash-language-server
    obsidian
    openssh
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

  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   enableAutosuggestions = true;
  #   enableSyntaxHighlighting = true;
  #   shellAliases = {
  #     c = "clear";
  #     e = "$EDITOR";
  #     v = "nvim";
  #     r = "ranger";
  #     ka = "killall";
  #     ez = "exec zsh";
  #     psag = "ps aux | ag";
  #   };
  # };

  home.file.".bashrc".text = ''
    # Setting Bash prompt. Capitalizes username and host if root user
    if [ "$EUID" -ne 0 ]
        then export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
        else export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]ROOT\[$(tput setaf 2)\]@\[$(tput setaf 4)\]$(hostname | awk '{print toupper($0)}') \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
    fi

    # shellcheck source=/dev/null
    source "$HOME/.profile"

    eval "$(direnv hook bash)"
  '';
}
