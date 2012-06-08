ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
DISABLE_LS_COLORS="true"

plugins=(git rails3 brew)
alias rake="noglob rake"

source $ZSH/oh-my-zsh.sh

# rvm
[[ -s "/Users/gmurphey_local/.rvm/scripts/rvm" ]] && source "/Users/gmurphey_local/.rvm/scripts/rvm"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting