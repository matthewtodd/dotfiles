# vim: set filetype=sh :

setopt append_history
export BUNDLER_EDITOR=vim
cdpath=${HOME}/Code
export CLICOLOR=yes
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GREP_COLOR='30;102'
export GREP_OPTIONS='--color'
setopt hist_ignore_all_dups
setopt hist_ignore_dups
export HISTFILE=${HOME}/.history
export HISTSIZE=1000
# LESS settings ganked from git (see core.pager in git-config(1))
# Used here because they're also convenient for ri.
export LESS='FRSX' #'--quit-if-one-screen --RAW-CONTROL-CHARS --chop-long-lines --no-init'
export PATH="${HOME}/.bin:${HOME}/.homebrew/bin:${PATH}:${HOME}/.rvm/bin:${HOME}/.vmware/bin"
export PGDATA="${HOME}/.homebrew/var/postgres"
setopt prompt_subst
export PS1=$'%{\e[36m%}$(__rvm_ps1)%{\e[0m%}%~%{\e[35m%}$(__git_ps1)%{\e[0m%} '
export RI='--format ansi'
export RSYNC_RSH='ssh'
export SAVEHIST=$HISTSIZE


case "$TERM" in
xterm*|rxvt*)
  # I'd like to use tput here as well, but my terminal doesn't support it.
  # http://serverfault.com/questions/23978/how-can-one-set-a-terminals-title-with-the-tput-command
  # export PS1='$(tput tsl)\W$(tput fsl)'$PS1
  export PS1=$'\e]0;%1~\a'$PS1
  ;;
*)
  ;;
esac

alias git=hub
alias gitx='gitx --all'
alias ls='ls -h'
alias migrate='rake db:migrate db:test:prepare'
alias screen='screen -c .screenrc'
alias ss='script/server -b 127.0.0.1'
alias v=mvim
alias rerun='AUTOTEST=true cucumber --profile rerun 2>&1 | less'
alias wip='AUTOTEST=true cucumber --profile wip 2>&1 | less'

function __git_ps1 {
  # TODO make some kind of working __git_ps1 again.
}

function __rvm_ps1 {
  if [ -x "${HOME}/.rvm/bin/rvm-prompt" ]; then
    printf "${1-(%s) }" "$(${HOME}/.rvm/bin/rvm-prompt v g s)"
  fi
}

function cdruby {
  cd `ruby -rrbconfig -e 'puts Config::CONFIG["rubylibdir"]'`; ls
}

function cpgem {
  cp ${HOME}/.gem/cache/$1 $2
}

# source ${HOME}/.homebrew/etc/bash_completion
# source ${HOME}/.homebrew/Library/Contributions/brew_bash_completion.sh
source ${HOME}/.rvm/scripts/rvm

# complete -W 'ls refresh start stop' downloads
# complete -W "$(ls ${HOME}/.gem/cache/)" cpgem
# complete -C 'rake-complete' rake
