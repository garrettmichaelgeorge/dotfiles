#! /usr/local/bin/zsh

# Adds `~/.scripts` and all subdirectories to $PATH
# export PATH="$(du $HOME/.scripts/ | cut -f2 | tr '\n' ':')$PATH"

# Environment variables
export EDITOR="nvim"
# export TERM="xterm-256color"
export TERMINAL="zsh"
if [ -n "$DISPLAY" ]; then
    export BROWSER="Chrome"
else 
    export BROWSER=links
fi
export DISABLE_SPRING=1
export WEB_CONCURRENCY=1
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
export BAT_THEME="gruvbox-dark"
export LS_COLORS="$(vivid generate solarized-dark)"
export CC="$HOME/.nix-profile/bin/gcc"

# Wine
export WINEPREFIX="$HOME/.wine/"
export PATH="/Applications/Wine Stable.app/Contents/Resources/wine/bin:$PATH"
export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
export DYLD_FALLBACK_LIBRARY_PATH="/usr/lib:/opt/X11/lib:$DYLD_FALLBACK_LIBRARY_PATH"

# # less/man colors
# export LESS=-R
# export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
# export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
# export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
# export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
# export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
# export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
# export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# asdf
export PATH="$HOME/.asdf/shims:$PATH"
export KERL_BUILD_DOCS=true
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"

# Load rbenv automatically
# eval "$(rbenv init -)"
# export PATH="/usr/local/opt/qt/bin:$PATH"
# export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Postgres
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# Add ElixirLS to $PATH
export PATH="$HOME/.elixir_ls/:$PATH"

# Homebrew recommended OpenSSL settings
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# Nix
export NIX_BUILD_CORES=0 # 0 means use all available CPU cores
if [ -e /Users/garrett.george/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/garrett.george/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export ITERM2_SQUELCH_MARK=0
