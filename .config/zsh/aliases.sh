# ls aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias edit='emacsclient -n'

alias sc='xclip -r -selection c'
# alias flutter_gitignore_path='$(dirname $(readlink $(which flutter)))/../.gitignore'
alias flutter_create='flutter create . && cp $(dirname $(readlink $(which flutter)))/../.gitignore . && git init && git add --all && git commit -m "First Commit"'
alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'
