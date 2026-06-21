for local_file in \
	"$DOT_FILES/.config/zsh/local/personal.zsh" \
	"$DOT_FILES/.config/zsh/local/work.zsh"; do
	if [[ -r "$local_file" ]]; then
		source "$local_file"
	fi
done
