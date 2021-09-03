set -x CLICOLOR yes
set -x EDITOR vim
set -x FZF_DEFAULT_COMMAND 'fd --hidden --type f'
set -x GOPATH $HOME/go
set -x GOROOT /usr/local/opt/go@1.16/libexec
set -x LESSHISTFILE -
set -x MACOSX_DEPLOYMENT_TARGET (sw_vers -productVersion)
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/Library/Caches
set -x XDG_DATA_HOME $HOME/Library/Application\ Support
set -x VIMINIT ":source $XDG_CONFIG_HOME/vim/vimrc"

set -g fish_user_paths "$HOME/.local/bin" /usr/local/opt/ruby/bin /usr/local/opt/go@1.16/bin /usr/local/opt/make/libexec/gnubin /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin $GOPATH/src/github.com/cockroachlabs/managed-service/bin

alias nvim="env VIMINIT= nvim"
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/config"
