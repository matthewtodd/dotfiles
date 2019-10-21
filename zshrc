autoload -U compinit
compinit

source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

RUBIES+=(/usr/local/Cellar/ruby/*)

export CLICOLOR=yes
export EDITOR=vim
export GIT_PS1_SHOWCOLORHINTS=yes
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GIT_PS1_SHOWUPSTREAM=verbose

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
export HISTORY_IGNORE='ls|ls *'

precmd() { __git_ps1 "%~" " " }
