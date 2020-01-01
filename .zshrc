# Path to your oh-my-zsh installation.
export ZSH="/Users/sminc/.oh-my-zsh"

# Warning: Failed to set locale category LC_COLLATE to en_CH.
#
export LC_ALL=en_US.UTF-8

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# zsh aliases
alias ll="ls -la"
alias zshc="vim ~/GitHub/.zshrc"
alias vimc="vim ~/GitHub/.vimrc"
alias zshs="source ~/GitHub/.zshrc"
alias vims="source ~/GitHub/.vimrc"
alias c="clang++ -std=c++17 -o app"
alias rmdir="rm -fr"
alias md='mkdir'

# git aliases
alias gpsh="git push"
alias gpll="git pull"
alias gs="git status"
alias gcln="git clone"

# mysql
alias mysql="/usr/local/mysql/bin/mysql -u root -p"
# alias ohmyzsh="mate ~/.oh-my-zsh"

prompt_context(){}
