set -gx CDPATH ~/Code
set -gx CLICOLOR yes
set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'fd --hidden --type f'
set -gx GIT_CONFIG_GLOBAL $HOME/.config/git/config
set -gx HOMEBREW_CELLAR '/opt/homebrew/Cellar';
set -gx HOMEBREW_PREFIX '/opt/homebrew';
set -gx HOMEBREW_REPOSITORY '/opt/homebrew';
set -gx INFOPATH '/opt/homebrew/share/info:'
set -gx LESSHISTFILE -
set -gx MANPATH '/opt/homebrew/share/man:'
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

fish_add_path -ag $HOME/.local/bin
fish_add_path -ag /opt/homebrew/bin
fish_add_path -ag /opt/homebrew/sbin
fish_add_path -ag /opt/homebrew/opt/libpq/bin

alias vim=nvim
