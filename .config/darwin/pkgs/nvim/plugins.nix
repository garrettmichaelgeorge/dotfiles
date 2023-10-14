{ pkgs }:

let
  vim-ruby-refactoring = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "vim-ruby-refactoring";
    version = "1970-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "ecomba";
      repo = "vim-ruby-refactoring";
      rev = "6447a4debc3263a0fa99feeab5548edf27ecf045";
      sha256 = "sha256-kNVj+a+Up7wPByzbcN8CL10ryOwVOs9IZ64O/6u7/Lk=";
    };
    meta.homepage = "https://github.com/ecomba/vim-ruby-refactoring";
  };

  # My nvim config as a plugin
  # This ensures all nvim code is added to the runtimepath
  garrett-config = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "garrett-config";
    version = "1970-01-01";
    src = ./garrett-config;
  };

  treesitterWithPlugins = (pkgs.vimPlugins.nvim-treesitter.withPlugins (
    # Use all available nvim-treesitter plugins
    # plugins: builtins.map (plugin: plugins.${plugin}) (builtins.attrNames plugins)
    plugins: with plugins; [
      bash
      c
      elixir
      erlang
      javascript
      lua
      nix
      python
      terraform
      tsx
      typescript
    ]
  ));
in
with pkgs.vimPlugins; [
  # My config as a plugin
  garrett-config

  # Other plugins
  asyncrun-vim
  auto-pairs
  emmet-vim
  vim-abolish
  vim-commentary
  vim-dispatch
  vim-endwise
  vim-eunuch
  vim-exchange
  vim-fugitive
  vim-indent-guides
  vim-indentwise
  vim-matchup
  vim-projectionist
  vim-rails
  vim-repeat
  vim-repeat
  vim-rhubarb # GitHub integration
  vim-sensible
  vim-surround
  vim-tbone
  vim-unimpaired

  # Finders
  ack-vim

  # IDE
  # LSP
  lspkind-nvim
  nvim-lspconfig
  nvim-web-devicons # Icons for use in trouble-nvim
  trouble-nvim

  # Completion, Snippets
  nvim-cmp

  cmp-buffer
  cmp-buffer
  cmp-cmdline
  cmp-git
  cmp-nvim-lsp
  cmp-nvim-ultisnips # UltiSnips snippets
  cmp-path
  cmp-treesitter
  cmp-vsnip
  cmp_luasnip
  friendly-snippets
  ultisnips # UltiSnips engine
  vim-snippets
  vim-vsnip
  vim-vsnip-integ

  # Telescope with dependencies and a faster backend
  plenary-nvim
  popup-nvim
  telescope-fzy-native-nvim
  telescope-nvim

  # TreeSitter
  nvim-treesitter-refactor
  nvim-treesitter-textobjects
  playground
  treesitterWithPlugins

  # Color
  gruvbox-material
  gruvbox-nvim
  lush-nvim
  material-nvim

  # Misc
  impatient-nvim
  nvim-lint

  # DB
  vim-dadbod
  vim-dadbod-ui
  vim-dadbod-completion

  # Test runner
  vim-test

  # Status bar
  vim-airline
  vim-airline-themes

  # Text objects
  vim-textobj-user

  # Language-specific
  vim-polyglot # collection of all language packs
  vimtex

  # Elixir
  elixir-tools-nvim
  # vim-textobj-elixir

  # Ruby
  vim-ruby-refactoring
]

