# vim: set filetype=sh :

# Use ~/.profile for things that can be inherited by subshells. As far as I
# know right now, that just means environment variables.

# histappend and HIST* envars from
# http://blog.macromates.com/2008/working-with-history-in-bash/
shopt -s histappend

export BUNDLER_EDITOR=mvim
export CDPATH=${HOME}/Code
export CLICOLOR=yes
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GREP_COLOR='30;102'
export GREP_OPTIONS='--color'
export HISTCONTROL=erasedups
export HISTSIZE=1000
# Necessary to get ImageMagick to compile
export HOMEBREW_USE_LLVM=true
# LESS settings ganked from git (see core.pager in git-config(1))
# Used here because they're also convenient for ri.
export LESS='FRSX' #'--quit-if-one-screen --RAW-CONTROL-CHARS --chop-long-lines --no-init'
export PATH="${HOME}/.bin:${HOME}/.homebrew/bin:${PATH}:${HOME}/.rvm/bin:${HOME}/.vmware/bin"
export PS1='\[$(CYAN)\]$(__rvm_ps1)\[$(RESET)\]\w\[$(MAGENTA)\]$(__git_ps1)\[$(RESET)\] '
export RI='--format ansi'
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
