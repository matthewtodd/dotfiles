set -x CDPATH ~/Personal/matthewtodd ~/Work ~/Documents/Cockroach\ Labs
set -x CLICOLOR yes
set -x EDITOR nvim
set -x FZF_DEFAULT_COMMAND 'fd --hidden --type f'
# us-east4 is closest to home:
# https://cloudpingtest.com/gcp
set -x GCEWORKER_NAME gceworker-todd
set -x GCEWORKER_ZONE us-east4-a
set -x GOROOT /usr/local/opt/go/libexec
set -x LESSHISTFILE -
set -x MACOSX_DEPLOYMENT_TARGET (sw_vers -productVersion)
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

fish_add_path -ag $HOME/.local/bin
fish_add_path -ag $HOME/.rd/bin
fish_add_path -ag /usr/local/opt/make/libexec/gnubin
fish_add_path -ag /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin

alias vim=nvim

status --is-interactive
and atuin init fish --disable-up-arrow | source
