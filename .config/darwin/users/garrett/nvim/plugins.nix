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
  vim-sensible
  vim-commentary
  vim-surround
  vim-endwise
  vim-eunuch
  vim-fugitive
  vim-rhubarb # GitHub integration
  vim-repeat
  vim-tbone
  vim-rails
  vim-dispatch
  vim-unimpaired
  vim-abolish
  vim-repeat
  vim-projectionist
  auto-pairs
  vim-indent-guides
  emmet-vim
  asyncrun-vim
  vim-exchange
  vim-matchup
  vim-indentwise

  # Color
  gruvbox-material

  # Finders
  ack-vim

  # IDE
  # LSP
  nvim-lspconfig
  trouble-nvim
  nvim-web-devicons # Icons for use in trouble-nvim
  lspkind-nvim

  # Completion, Snippets
  nvim-cmp

  cmp-buffer
  cmp-buffer
  cmp-cmdline
  cmp-nvim-lsp
  cmp-path
  cmp-vsnip
  vim-vsnip
  vim-vsnip-integ
  friendly-snippets
  cmp_luasnip
  cmp-treesitter
  cmp-git
  # UltiSnips engine
  ultisnips
  # UltiSnips snippets
  vim-snippets
  cmp-nvim-ultisnips


  # Telescope with dependencies and a faster backend
  popup-nvim
  plenary-nvim
  telescope-nvim
  telescope-fzy-native-nvim

  # TreeSitter
  treesitterWithPlugins
  playground
  nvim-treesitter-refactor
  nvim-treesitter-textobjects

  # Color
  lush-nvim
  gruvbox-nvim
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

