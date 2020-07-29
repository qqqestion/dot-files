# Path to your oh-my-zsh installation.
# export ZSH="~/.oh-my-zsh"
ZSH=$HOME/.oh-my-zsh

# this makes vim works with cntr-s command
stty -ixon

# Warning: Failed to set locale category LC_COLLATE to en_CH.
#
export LC_ALL=en_US.UTF-8
export PYTHONPATH=${PYTHONPATH}:/Library/Python/3.8/site-packages

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME='spaceship'

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export DOT_FILES='~/GitHub/dot-files'

# zsh aliases
alias ll="ls -la"
alias zshc="vim $DOT_FILES/.zshrc"
alias vimc="vim $DOT_FILES/.vimrc"
alias zshs="source $DOT_FILES/.zshrc"
alias vims="source $DOT_FILES/.vimrc"
alias rmdir="rm -fr"
alias md='mkdir'

# git aliases
alias ga="git add"
alias gct="git commit -m"
alias gpush="git push"
alias gpull="git pull"
alias gs="git status"
alias gc="git clone"
alias gd="git diff"

# mysql
alias mysql="/usr/local/mysql/bin/mysql -u root -p"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# programming aliases
alias c="clang++ -std=c++17 -o app"
# alias python="python3.8"

prompt_context(){}
