ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
DISABLE_LS_COLORS="true"

setopt AUTO_CD

plugins=(git rails3 brew)

#aliases
alias rake="noglob rake"
alias g="git"

source $ZSH/oh-my-zsh.sh

# rvm
[[ -s "~/.rvm/scripts/rvm" ]] && source "~/.rvm/scripts/rvm"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting