[ ! -f ~/.shortcuts ] && shortcuts >/dev/null 2>&1

[ -f ~/.bashrc ] && source "$HOME/.bashrc"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export PATH="/usr/local/opt/qt/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
if [ -e /Users/garrett.george/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/garrett.george/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
