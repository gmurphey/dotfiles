ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.zsh-custom
ZSH_THEME="gmurphey"

plugins=(git)

#aliases
source $ZSH/oh-my-zsh.sh

setopt auto_cd
unsetopt correct_all

# user-specific bin
PATH=$PATH:$HOME/bin

export GOPATH=$HOME/git/go
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"