#!/bin/bash

# NOTE: most aliases, etc. are now in ~/.profile

# shopt -s autocd #Allows you to cd into directory merely by typing the directory name.

# shellcheck source=/dev/null
source "$HOME/.profile"

# Shell hooks
eval "$(direnv hook bash)"
eval "$(starship init bash)"
