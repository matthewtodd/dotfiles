# vim: set filetype=sh :

# Use ~/.profile for things that can be inherited by subshells. As far as I
# know right now, that just means environment variables.

# histappend and HIST* envars from
# http://blog.macromates.com/2008/working-with-history-in-bash/
shopt -s histappend

export CLICOLOR=yes
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GREP_COLOR='30;102'
export GREP_OPTIONS='--color'
export HISTCONTROL=erasedups
export HISTSIZE=1000
export PATH="${HOME}/.bin:${HOME}/.homebrew/bin:${HOME}/.rvm/bin:${PATH}:/Library/Application Support/VMware Fusion"
export PS1='$(tput setaf 6)$(__rvm_ps1 "(%s) ")$(__bundler_ps1 "(%s) ")$(tput sgr0)\w$(tput setaf 5)$(__git_ps1 " %s")$(tput sgr0) '
export RSYNC_RSH='ssh'

case "$TERM" in
xterm*|rxvt*)
  # I'd like to use tput here as well, but my terminal doesn't support it.
  # http://serverfault.com/questions/23978/how-can-one-set-a-terminals-title-with-the-tput-command
  # export PS1='$(tput tsl)\W$(tput fsl)'$PS1
  export PS1="\[\e]0;\W\a\]"$PS1
  ;;
*)
  ;;
esac

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
