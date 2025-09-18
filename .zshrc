# Source common shell aliases from .profile
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/bin:/usr/bin:/usr/local/bin:$PATH

# Functions
source_if_exists () {
    local path="$1"
    [[ -f "$path" ]] && source "$path"
}

# ImageMagick resize
# from: https://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/
# Example usage: smartresize inputfile.png 300 outputdir/
smartresize() {
    mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

# Simplified version of the above for compressing web images (one argument only)
# compresses to width of 2500px and stores in pwd
# Example usage: smartresize_2500 inputfile.png
smartresize_2500() {
    mogrify -path . -filter Triangle -define filter:support=2 -thumbnail 2500 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

giffy() {
    local input_file=$1
    local output_file=$2

    ffmpeg -i $input_file -s 1280x960 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $output_file
}

# ALIASES
alias c="clear"
alias e="$EDITOR"
alias v="nvim"
alias r="ranger"
alias ka="killall"
alias mkd="mkdir -pv"
alias REF="source $PATH"
alias ez="exec zsh"
alias psag="ps aux | ag"

# Git
alias g="git"
alias gpuo="git push -u origin $(git branch --show-current)"

# ssh
if [[ $TERM == "xterm-kitty" ]]; then
    alias kssh="kitty +kitten ssh"
fi

# Adding color
# alias ls='ls -1a'
alias ls="ls -1a --color"
alias grep="grep --color=auto"
# alias diff="diff --color=auto"
alias ccat="highlight --out-format=ansi" # Color cat - print file with syntax highlighting.

# Internet
alias yt="youtube-dl --add-metadata -ic" # Download video link
alias yta="yt -x -f bestaudio/best" # Download only audio
alias YT="youtube-viewer"

# Ruby & Rails
alias rb="ruby"
alias be="bundle exec"
alias bejs="bundle exec jekyll serve"
alias bers="bundle exec rails server"
alias bd="bin/deploy"
alias rs="bin/rails server -b $LOCAL_IP_ADDRESS"
alias rre="touch tmp/restart.txt" # restarts Rails server
alias rc="bin/rails console"
alias rcs="bin/rails console --sandbox"
alias wp="bin/webpack-dev-server"

# Javascript
alias ys="yarn start"
alias yu="yarn upgrade"

# Elixir
alias mps="mix phx.server"
alias mt="mix test"
alias mto="mix test --only"
alias mtc="mix test --cover"

# Heroku
alias hlt="heroku logs --tail"
alias ha="heroku addons"
alias hai="heroku addons" # requires the name of the addon as argument

# Terraform
alias tf="terraform"

# Wine
# Launch Steam on Wine
alias steam_wine="wine ~/.wine/drive_c/Program\ Files\ (x86)/Steam/steam.exe -no-cef-sandbox"

# Download
alias license_mit='curl https://opensource.org/licenses/MIT >> ./LICENSE'

# Scripts
alias random_subdomain="ruby ~/bin/ruby/random_subdomain.rb"
alias largest_file='ruby ~/bin/ruby/largest_file.rb'
alias tic_tac_toe='ruby ~/bin/ruby/tic_tac_toe/tic_tac_toe.rb'
alias remove_dumb_macos_duplicates='~/bin/remove_dumb_macos_duplicates'
alias true_colors="bash ~/bin/true_colors.sh"

# Git dotfiles workflow
# Read more: https://www.atlassian.com/git/tutorials/dotfiles
alias config='/usr/bin/env git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Elixir
alias mps='mix phx.server'
alias mdg='mix deps.get'
alias mtw='fswatch --latency=0.1 --one-per-batch -r lib test | mix test --warnings-as-errors --exclude not_implemented:true --listen-on-stdin'
alias imps='iex -S mix phx.server'

alias tn="terminal-notifier"

alias cfv="cd ~/.config/nvim && nvim ~/.vim/vimrc"
alias myip="curl ipinfo.io/ip"

alias cf="cd ~/.config"

# Nix
alias nr="nix run"
alias nb="nix build"
alias nfc='nix flake check'

# Mise
alias m="mise"
alias mr="mise run"

# Secret aliases that are git-ignored
source_if_exists $HOME/.secret_aliases

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
