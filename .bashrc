#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


[[ -f ~/.config/bash/aliases.sh ]] && . ~/.config/bash/aliases.sh
[[ -f ~/.config/bash/variables.sh ]] && . ~/.config/bash/variables.sh
[[ -f ~/.config/bash/config.sh ]] && . ~/.config/bash/config.sh
[[ -f ~/.pde/scripts/pde-bash-completion.sh ]] && . ~/.pde/scripts/pde-bash-completion.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
alias ci="/Users/bp973/.prezi/frontend-packages/node_modules/.bin/ci"
alias bach="/Users/bp973/.prezi/frontend-packages/node_modules/.bin/bach"
