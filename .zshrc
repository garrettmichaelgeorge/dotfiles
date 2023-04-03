# Source common shell aliases from .profile
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/bin:/usr/bin:/usr/local/bin:$PATH

# Custom aliases
source $HOME/.custom_aliases

# Typewritten ZSH prompt
source $HOME/.typewrittenrc
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

# asdf version manager
. $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

# test -e $HOME/.iterm2_shell_integration.zsh && source $HOME/.iterm2_shell_integration.zsh || true
eval "$(direnv hook zsh)"
source /Users/garrett/.config/op/plugins.sh
