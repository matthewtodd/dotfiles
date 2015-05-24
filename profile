source /usr/local/etc/bash_completion

export CLICOLOR=yes
export EDITOR=vim
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export PS1='\w\[$(tput setaf 6)\]$(__git_ps1)\[$(tput sgr 0)\] '
