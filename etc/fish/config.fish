set -x CLICOLOR yes
set -x EDITOR nvim
set -x FZF_DEFAULT_COMMAND 'fd --hidden --type f'
# us-east4 is closest to home:
# https://cloudpingtest.com/gcp
set -x GCEWORKER_NAME gceworker-todd
set -x GCEWORKER_ZONE us-east4-a
set -x GOPATH $HOME/go
set -x GOROOT /usr/local/opt/go/libexec
set -x LESSHISTFILE -
set -x MACOSX_DEPLOYMENT_TARGET (sw_vers -productVersion)
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/Library/Caches
set -x XDG_DATA_HOME $HOME/Library/Application\ Support

fish_add_path -ag $HOME/.local/bin
fish_add_path -ag $HOME/.rd/bin
fish_add_path -ag /usr/local/opt/go/bin
fish_add_path -ag /usr/local/opt/make/libexec/gnubin
fish_add_path -ag /usr/local/opt/python@3.9/libexec/bin
fish_add_path -ag /usr/local/opt/ruby/bin
fish_add_path -ag /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin

alias dev=$GOPATH/src/github.com/cockroachdb/cockroach/dev
alias vim=nvim
