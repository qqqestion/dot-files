Hi
It's just my dot files for vim, zsh, etc

## Install

Run the installer from any directory:

```sh
/path/to/dot-files/launch.sh
```

The script discovers the repository from its own location, so the clone can live
anywhere. It links tracked files into your home directory instead of copying
them:

- `~/.zshrc` -> this repo's `.zshrc`
- `~/.tmux.conf` -> this repo's `.tmux.conf`
- `${XDG_CONFIG_HOME:-~/.config}/ghostty/config` -> this repo's `.config/ghostty/config`
- `${XDG_CONFIG_HOME:-~/.config}/nvim` -> this repo's `.config/nvim`

Because these are symlinks, edits through either the home path or the repository
path update the same files and stay visible to git.

The installer is idempotent. If a destination already points to the right file,
it is left unchanged. If a destination exists but is not the expected symlink,
the script stops without overwriting it. To move conflicts aside automatically:

```sh
/path/to/dot-files/launch.sh --backup
```

Conflicting files are moved under `~/.dotfiles-backup/<timestamp>/` before the
symlink is created.

The script sets `zsh` as the current user's login shell with `chsh` when it is
not already configured. It uses a `zsh` path listed in `/etc/shells`, so `chsh`
does not reject it. To skip changing the login shell:

```sh
/path/to/dot-files/launch.sh --skip-shell
```

If oh-my-zsh is missing, the script installs it into `${ZSH:-~/.oh-my-zsh}` with
`git clone`. It also installs the custom theme and plugins used by this config
when they are missing:

- `spaceship-prompt`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`

To skip the oh-my-zsh setup step entirely:

```sh
/path/to/dot-files/launch.sh --skip-oh-my-zsh
```

The script checks whether `zsh`, `tmux`, and `nvim` are available. `zsh` is
required because the installer makes it the login shell. Missing `tmux` or
`nvim` are reported as warnings by default. To let the script install missing
packages with Homebrew or apt:

```sh
/path/to/dot-files/launch.sh --install-deps
```

## Local Neovim config

The Neovim config lives in `.config/nvim` and is designed to run from this
repository without touching files in your home directory.

Run it with repo-local XDG paths:

```sh
XDG_CONFIG_HOME="$PWD/.config" \
XDG_DATA_HOME="$PWD/.config/nvim/.local/share" \
XDG_STATE_HOME="$PWD/.config/nvim/.local/state" \
XDG_CACHE_HOME="$PWD/.config/nvim/.cache" \
nvim
```

## Local zsh config

Run zsh against this repo with `ZDOTDIR` pointing at the repository root:

```sh
ZDOTDIR="$PWD" zsh
```

The tracked `.zshrc` is a thin loader. Shared shell bits live under `.config/zsh/`,
and optional private config can be copied from:

- `.config/zsh/local/personal.zsh.example` -> `.config/zsh/local/personal.zsh`
- `.config/zsh/local/work.zsh.example` -> `.config/zsh/local/work.zsh`

Put secrets, machine-specific env, and private aliases in those real files.
Personal loads first, then work overrides it.
