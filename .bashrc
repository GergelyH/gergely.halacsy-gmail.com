#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


[[ -f ~/.config/bash/aliases.sh ]] && . ~/.config/bash/aliases.sh
[[ -f ~/.config/bash/variables.sh ]] && . ~/.config/bash/variables.sh
[[ -f ~/.config/bash/config.sh ]] && . ~/.config/bash/config.sh
