# vim: set filetype=sh :

# Use ~/.profile for things that can be inherited by subshells. As far as I
# know right now, that just means environment variables.

# histappend and HIST* envars from
# http://blog.macromates.com/2008/working-with-history-in-bash/
shopt -s histappend

export CLICOLOR=yes
export EDITOR=vim
export GEM_OPEN_EDITOR=mvim
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GREP_COLOR='30;102'
export GREP_OPTIONS='--color'
export HISTCONTROL=erasedups
export HISTSIZE=1000
export PATH="${HOME}/.bin:${HOME}/.gem/ruby/1.8/bin:${HOME}/.homebrew/bin:${PATH}"
export PS1='\[\e[36m\]$(__bundler_ps1 "[%s] ")\[\e[0m\]\w\[\e[35m\]$(__git_ps1 " %s")\[\e[0m\] '
export RSYNC_RSH='ssh'

case "$TERM" in
xterm*|rxvt*)
  export PS1="\[\e]0;\W\a\]${PS1}"
  ;;
*)
  ;;
esac

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
