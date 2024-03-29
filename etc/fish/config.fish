set -x CDPATH ~/Code
set -x CLICOLOR yes
set -x EDITOR nvim
set -x FZF_DEFAULT_COMMAND 'fd --hidden --type f'
set -x HOMEBREW_CELLAR '/opt/homebrew/Cellar';
set -x HOMEBREW_PREFIX '/opt/homebrew';
set -x HOMEBREW_REPOSITORY '/opt/homebrew';
set -x INFOPATH '/opt/homebrew/share/info:'
set -x LESSHISTFILE -
set -x MANPATH '/opt/homebrew/share/man:'
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

fish_add_path -ag $HOME/.local/bin
fish_add_path -ag /opt/homebrew/bin
fish_add_path -ag /opt/homebrew/sbin

alias vim=nvim

mise activate fish | source
