#!/usr/bin/env bash
set -euo pipefail

BACKUP=0
INSTALL_DEPS=0
SKIP_OH_MY_ZSH=0
SKIP_SHELL_CHANGE=0

usage() {
	cat <<'EOF'
Usage: ./launch.sh [options]

Install dotfiles by linking them from this repository into your home directory.

Options:
  --backup          Move conflicting files to ~/.dotfiles-backup/<timestamp>/
  --install-deps    Install missing zsh, tmux, and nvim with a supported package manager
  --skip-oh-my-zsh  Do not install oh-my-zsh, its theme, or its plugins
  --skip-shell      Do not change the current user's login shell
  -h, --help        Show this help
EOF
}

for arg in "$@"; do
	case "$arg" in
		--backup)
			BACKUP=1
			;;
		--install-deps)
			INSTALL_DEPS=1
			;;
		--skip-oh-my-zsh)
			SKIP_OH_MY_ZSH=1
			;;
		--skip-shell)
			SKIP_SHELL_CHANGE=1
			;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			printf 'Unknown option: %s\n\n' "$arg" >&2
			usage >&2
			exit 2
			;;
	esac
done

resolve_repo_dir() {
	local source dir
	source="${BASH_SOURCE[0]}"

	while [[ -L "$source" ]]; do
		dir="$(cd -P "$(dirname "$source")" >/dev/null 2>&1 && pwd)"
		source="$(readlink "$source")"
		[[ "$source" == /* ]] || source="$dir/$source"
	done

	cd -P "$(dirname "$source")" >/dev/null 2>&1 && pwd
}

absolute_path() {
	local path dir base
	path="$1"
	dir="$(dirname "$path")"
	base="$(basename "$path")"
	printf '%s/%s\n' "$(cd -P "$dir" >/dev/null 2>&1 && pwd)" "$base"
}

relative_path() {
	local target base common_index rel index
	local -a target_parts base_parts

	target="$(absolute_path "$1")"
	base="$(absolute_path "$2")"

	IFS=/ read -r -a target_parts <<< "${target#/}"
	IFS=/ read -r -a base_parts <<< "${base#/}"

	common_index=0
	while [[ $common_index -lt ${#target_parts[@]} && $common_index -lt ${#base_parts[@]} ]]; do
		[[ "${target_parts[$common_index]}" == "${base_parts[$common_index]}" ]] || break
		((common_index += 1))
	done

	rel=""
	for ((index = common_index; index < ${#base_parts[@]}; index += 1)); do
		rel+="../"
	done

	for ((index = common_index; index < ${#target_parts[@]}; index += 1)); do
		rel+="${target_parts[$index]}"
		if [[ $index -lt $((${#target_parts[@]} - 1)) ]]; then
			rel+="/"
		fi
	done

	printf '%s\n' "${rel:-.}"
}

link_target_path() {
	local link target
	link="$1"
	target="$(readlink "$link")"
	if [[ "$target" == /* ]]; then
		absolute_path "$target"
	else
		absolute_path "$(dirname "$link")/$target"
	fi
}

ensure_parent_dir() {
	mkdir -p "$(dirname "$1")"
}

backup_path_for() {
	local dest relative
	dest="$1"
	relative="${dest#$HOME/}"
	printf '%s/%s\n' "$BACKUP_DIR" "$relative"
}

link_dotfile() {
	local source dest target backup_dest
	source="$1"
	dest="$2"

	if [[ -L "$dest" && "$(link_target_path "$dest")" == "$(absolute_path "$source")" ]]; then
		printf 'ok: %s already points to %s\n' "$dest" "$source"
		return
	fi

	if [[ -e "$dest" || -L "$dest" ]]; then
		if [[ "$BACKUP" -ne 1 ]]; then
			printf 'conflict: %s already exists. Re-run with --backup to move it aside.\n' "$dest" >&2
			return 1
		fi

		backup_dest="$(backup_path_for "$dest")"
		ensure_parent_dir "$backup_dest"
		mv "$dest" "$backup_dest"
		printf 'backup: %s -> %s\n' "$dest" "$backup_dest"
	fi

	ensure_parent_dir "$dest"
	target="$(relative_path "$source" "$(dirname "$dest")")"
	ln -s "$target" "$dest"
	printf 'link: %s -> %s\n' "$dest" "$target"
}

install_missing_deps() {
	local -a missing packages
	local cmd

	missing=()
	packages=()
	for cmd in zsh tmux nvim; do
		if ! command -v "$cmd" >/dev/null 2>&1; then
			missing+=("$cmd")
		fi
	done

	if [[ ${#missing[@]} -eq 0 ]]; then
		printf 'ok: zsh, tmux, and nvim are available\n'
		return
	fi

	if [[ "$INSTALL_DEPS" -ne 1 ]]; then
		printf 'warning: missing commands: %s\n' "${missing[*]}" >&2
		printf 'warning: install them manually or re-run with --install-deps\n' >&2
		return
	fi

	for cmd in "${missing[@]}"; do
		if [[ "$cmd" == nvim ]]; then
			packages+=(neovim)
		else
			packages+=("$cmd")
		fi
	done

	if command -v brew >/dev/null 2>&1; then
		brew install "${packages[@]}"
	elif command -v apt-get >/dev/null 2>&1; then
		sudo apt-get update
		sudo apt-get install -y "${packages[@]}"
	else
		printf 'error: no supported package manager found for: %s\n' "${missing[*]}" >&2
		exit 1
	fi
}

current_user() {
	id -un
}

current_login_shell() {
	local user line shell
	user="$(current_user)"

	if command -v dscl >/dev/null 2>&1; then
		line="$(dscl . -read "/Users/$user" UserShell 2>/dev/null || true)"
		if [[ "$line" == UserShell:* ]]; then
			shell="${line#UserShell: }"
			if [[ -n "$shell" ]]; then
				printf '%s\n' "$shell"
				return
			fi
		fi
	fi

	if command -v getent >/dev/null 2>&1; then
		line="$(getent passwd "$user" 2>/dev/null || true)"
		if [[ -n "$line" ]]; then
			IFS=: read -r _ _ _ _ _ _ shell <<< "$line"
			if [[ -n "$shell" ]]; then
				printf '%s\n' "$shell"
				return
			fi
		fi
	fi

	printf '%s\n' "${SHELL:-}"
}

shells_file() {
	printf '%s\n' "${DOTFILES_SHELLS_FILE:-/etc/shells}"
}

shell_is_allowed() {
	local shell shells line
	shell="$1"
	shells="$(shells_file)"

	[[ -r "$shells" ]] || return 1
	while IFS= read -r line; do
		[[ "$line" == "$shell" ]] && return 0
	done < "$shells"

	return 1
}

zsh_login_shell_path() {
	local zsh_path

	if ! zsh_path="$(command -v zsh 2>/dev/null)"; then
		printf 'error: zsh is not installed. Install it manually or re-run with --install-deps.\n' >&2
		exit 1
	fi

	if shell_is_allowed "$zsh_path"; then
		printf '%s\n' "$zsh_path"
		return
	fi

	if [[ -x /bin/zsh ]] && shell_is_allowed /bin/zsh; then
		printf '%s\n' /bin/zsh
		return
	fi

	printf 'error: %s is not listed in %s, so chsh will reject it.\n' "$zsh_path" "$(shells_file)" >&2
	printf 'error: add it to %s or install a system zsh listed there.\n' "$(shells_file)" >&2
	exit 1
}

configure_login_shell() {
	local user current_shell zsh_path

	if [[ "$SKIP_SHELL_CHANGE" -eq 1 ]]; then
		printf 'skip: login shell change\n'
		return
	fi

	user="$(current_user)"
	current_shell="$(current_login_shell)"
	zsh_path="$(zsh_login_shell_path)"

	if [[ "$current_shell" == "$zsh_path" ]]; then
		printf 'ok: login shell is already %s\n' "$zsh_path"
		return
	fi

	if ! command -v chsh >/dev/null 2>&1; then
		printf 'error: chsh is required to set login shell to %s\n' "$zsh_path" >&2
		exit 1
	fi

	chsh -s "$zsh_path" "$user"
	printf 'shell: %s -> %s\n' "$user" "$zsh_path"
}

require_git() {
	if ! command -v git >/dev/null 2>&1; then
		printf 'error: git is required to install oh-my-zsh dependencies\n' >&2
		exit 1
	fi
}

clone_if_missing() {
	local url dest marker
	url="$1"
	dest="$2"
	marker="$3"

	if [[ -e "$marker" ]]; then
		printf 'ok: %s is installed\n' "$dest"
		return
	fi

	if [[ -e "$dest" ]]; then
		printf 'error: %s exists but expected marker is missing: %s\n' "$dest" "$marker" >&2
		exit 1
	fi

	require_git
	mkdir -p "$(dirname "$dest")"
	git clone --depth=1 "$url" "$dest"
	printf 'install: %s -> %s\n' "$url" "$dest"
}

install_oh_my_zsh() {
	local zsh_dir parent_dir
	zsh_dir="${ZSH:-$HOME/.oh-my-zsh}"

	if [[ "$SKIP_OH_MY_ZSH" -eq 1 ]]; then
		printf 'skip: oh-my-zsh installation\n'
		return
	fi

	if [[ -r "$zsh_dir/oh-my-zsh.sh" ]]; then
		printf 'ok: oh-my-zsh is installed at %s\n' "$zsh_dir"
		return
	fi

	if [[ -e "$zsh_dir" ]]; then
		printf 'error: %s exists but does not contain oh-my-zsh.sh\n' "$zsh_dir" >&2
		printf 'error: move it aside or set ZSH to another directory, then re-run.\n' >&2
		exit 1
	fi

	require_git
	parent_dir="$(dirname "$zsh_dir")"
	mkdir -p "$parent_dir"
	git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$zsh_dir"
	printf 'install: oh-my-zsh -> %s\n' "$zsh_dir"
}

install_oh_my_zsh_extensions() {
	local zsh_dir custom_dir spaceship_dir spaceship_link
	zsh_dir="${ZSH:-$HOME/.oh-my-zsh}"
	custom_dir="${ZSH_CUSTOM:-$zsh_dir/custom}"
	spaceship_dir="$custom_dir/themes/spaceship-prompt"
	spaceship_link="$custom_dir/themes/spaceship.zsh-theme"

	if [[ "$SKIP_OH_MY_ZSH" -eq 1 ]]; then
		return
	fi

	clone_if_missing \
		'https://github.com/zsh-users/zsh-autosuggestions.git' \
		"$custom_dir/plugins/zsh-autosuggestions" \
		"$custom_dir/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"

	clone_if_missing \
		'https://github.com/zsh-users/zsh-syntax-highlighting.git' \
		"$custom_dir/plugins/zsh-syntax-highlighting" \
		"$custom_dir/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"

	clone_if_missing \
		'https://github.com/spaceship-prompt/spaceship-prompt.git' \
		"$spaceship_dir" \
		"$spaceship_dir/spaceship.zsh-theme"

	if [[ -L "$spaceship_link" && "$(readlink "$spaceship_link")" == 'spaceship-prompt/spaceship.zsh-theme' ]]; then
		printf 'ok: %s is installed\n' "$spaceship_link"
	elif [[ -e "$spaceship_link" || -L "$spaceship_link" ]]; then
		printf 'error: %s already exists and is not managed by this installer\n' "$spaceship_link" >&2
		exit 1
	else
		mkdir -p "$(dirname "$spaceship_link")"
		ln -s 'spaceship-prompt/spaceship.zsh-theme' "$spaceship_link"
		printf 'link: %s -> spaceship-prompt/spaceship.zsh-theme\n' "$spaceship_link"
	fi
}

main() {
	local repo_dir config_home
	repo_dir="$(resolve_repo_dir)"
	config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

	if [[ "$BACKUP" -eq 1 ]]; then
		BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
	fi

	install_missing_deps
	configure_login_shell
	install_oh_my_zsh
	install_oh_my_zsh_extensions

	link_dotfile "$repo_dir/.zshrc" "$HOME/.zshrc"
	link_dotfile "$repo_dir/.tmux.conf" "$HOME/.tmux.conf"
	link_dotfile "$repo_dir/.config/nvim" "$config_home/nvim"
}

main
