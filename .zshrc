export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH" # required by pipx for example

bindkey -v

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
