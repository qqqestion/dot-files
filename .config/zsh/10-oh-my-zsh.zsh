ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME=''

plugins=(
	colored-man-pages
	python
	zsh-autosuggestions
	zsh-syntax-highlighting
)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
	source "$ZSH/oh-my-zsh.sh"
fi
