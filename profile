source /usr/local/etc/bash_completion

shopt -s cmdhist

export CLICOLOR=yes
export EDITOR=vim
export GIT_PS1_SHOWCOLORHINTS=yes
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GIT_PS1_SHOWUPSTREAM=verbose
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls'
export PROMPT_COMMAND='echo -ne "\033]7;file://${hostname}:${PWD}\007"; __git_ps1 "\w" " "'
export PS1='\w '
