export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH" # required by pipx for example

bindkey -v

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
