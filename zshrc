ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gmurphey"

plugins=(git rails3 brew)

#aliases
alias rake="noglob rake"
alias g="git"
alias server="sudo python -m SimpleHTTPServer 80"

source $ZSH/oh-my-zsh.sh

setopt auto_cd
unsetopt correct_all

# user-specific bin
PATH=$PATH:$HOME/bin

# rvm
[[ -s "~/.rvm/scripts/rvm" ]] && source "~/.rvm/scripts/rvm"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
