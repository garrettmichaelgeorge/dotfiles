#!/bin/bash
#  _               _
# | |__   __ _ ___| |__  _ __ ___
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__
# |_.__/ \__,_|___/_| |_|_|  \___|

##################################
###### ABOUT THIS .BASHRC  #######
##################################

# Modfied version of .bashrc from Luke Smith (@lukesmithxyz), followed by my additions — GMG
#

##################################
###### BEGIN @LUKESMITHXYZ  ######
##################################

# shopt -s autocd #Allows you to cd into directory merely by typing the directory name.

# Setting Bash prompt. Capitalizes username and host if root user (my root user uses this same config file).
if [ "$EUID" -ne 0 ]
    then export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
    else export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]ROOT\[$(tput setaf 2)\]@\[$(tput setaf 4)\]$(hostname | awk '{print toupper($0)}') \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
fi

# System Maintainence
# alias sdn="sudo shutdown now"

# Some aliases
alias e="$EDITOR"
alias sysctl="systemctl"
alias v="vim"
alias r="ranger"
alias ka="killall"
alias g="git"
alias mkd="mkdir -pv"
alias ref="shortcuts && source ~/.bashrc" # Refresh shortcuts manually and reload bashrc
alias REF="source $PATH"

# Adding color
alias ls='ls -1a'
alias grep="grep --color=auto"
alias diff="diff --color=auto"
# alias ccat="highlight --out-format=ansi" # Color cat - print file with syntax highlighting.

# Internet
alias yt="youtube-dl --add-metadata -ic" # Download video link
alias yta="yt -x -f bestaudio/best" # Download only audio
alias YT="youtube-viewer"

##################################
## BEGIN @GARRETTMICHAELGEORGE ###
##################################

### ALIASES
# General
alias c="clear"
alias rb="ruby"
alias be="bundle exec"
alias bejs="bundle exec jekyll serve"
alias bers="bundle exec rails server"
alias restart_rails='kill -9 `cat tmp/pids/server.pid` && bundle exec rails server'

# Download
alias license_mit='curl https://opensource.org/licenses/MIT >> ./LICENSE'

# Scripts
alias random_subdomain="ruby ~/.scripts/ruby/random_subdomain.rb"
alias largest_file='ruby ~/.scripts/ruby/largest_file.rb'
alias tic_tac_toe='ruby ~/.scripts/ruby/tic_tac_toe/tic_tac_toe.rb'

# Connect to bluetooth
alias bt="BluetoothConnector"
alias btdoss="bt fc-58-fa-a6-ca-43"
alias doss='fc-58-fa-a6-ca-43'

# Git dotfiles workflow
alias config='/usr/bin/git --git-dir=/Users/garrettgeorge/.cfg/ --work-tree=/Users/garrettgeorge'

# ImageMagick resize
# from: https://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/
# Example usage: smartresize inputfile.png 300 outputdir/
smartresize() {
    mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

### Simplified version for compressing web images (one argument only)
# compresses to width of 2500px and stores in pwd
# Example usage: smartresize_2500 inputfile.png
smartresize_2500() {
    mogrify -path . -filter Triangle -define filter:support=2 -thumbnail 2500 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source $HOME/.shortcuts
source /Users/garrettgeorge/.shortcuts

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

