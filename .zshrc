export DOT_FILES="${${(%):-%N}:A:h}"

for zsh_file in "$DOT_FILES"/.config/zsh/*.zsh; do
	source "$zsh_file"
done
