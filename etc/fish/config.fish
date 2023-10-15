set -x CDPATH ~/Code
set -x CLICOLOR yes
set -x EDITOR nvim
set -x FZF_DEFAULT_COMMAND 'fd --hidden --type f'
set -x LESSHISTFILE -
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

fish_add_path -ag $HOME/.local/bin

alias vim=nvim

status --is-interactive
and atuin init fish --disable-up-arrow | source
