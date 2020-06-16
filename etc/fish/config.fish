set -x CLICOLOR yes
set -x EDITOR vim
set -x FZF_DEFAULT_COMMAND 'fd --hidden --type f'
set -x LESSHISTFILE -
set -x PATH $PATH $HOME/.local/bin
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/Library/Caches
set -x XDG_DATA_HOME $HOME/Library/Application\ Support
set -x VIMINIT ":source $XDG_CONFIG_HOME/vim/vimrc"
