# Source common shell aliases from .profile
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

# Enable incremental reverse history search using CTRL-R
# (an emacs keybinding; this is available by default when using bindkey -e
# (emacs emulation mode) but not when using bindkey -v (vi emulation mode)).
# Is there a more vi-like way to do this?
# See:
# - man zshzle
# - https://unix.stackexchange.com/q/30168/how-to-enable-reverse-search-in-zsh#comment-1035628 (comment #2)
bindkey '^R' history-incremental-search-backward

# fzf
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# https://github.com/junegunn/fzf-git.sh
source_if_exists "$HOME/.config/fzf/fzf-git.sh/fzf-git.sh"

# Shell integration
eval "$(direnv hook zsh)"
# Starship prompt https://starship.rs/
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
source <(fzf --zsh)
[ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ] && source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh
