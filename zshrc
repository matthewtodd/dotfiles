# vim: set filetype=sh :

# shopt -s histappend

export BUNDLER_EDITOR=vim
export CDPATH=${HOME}/Code
export CLICOLOR=yes
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GREP_COLOR='30;102'
export GREP_OPTIONS='--color'
# export HISTCONTROL=erasedups
# export HISTSIZE=1000
# LESS settings ganked from git (see core.pager in git-config(1))
# Used here because they're also convenient for ri.
export LESS='FRSX' #'--quit-if-one-screen --RAW-CONTROL-CHARS --chop-long-lines --no-init'
export PATH="${HOME}/.bin:${HOME}/.homebrew/bin:${PATH}:${HOME}/.rvm/bin:${HOME}/.vmware/bin"
export PGDATA="${HOME}/.homebrew/var/postgres"
# export PS1='\[$(CYAN)\]$(__rvm_ps1)\[$(RESET)\]\w\[$(MAGENTA)\]$(__git_ps1)\[$(RESET)\] '
export RI='--format ansi'
export RSYNC_RSH='ssh'

# case "$TERM" in
# xterm*|rxvt*)
  # # I'd like to use tput here as well, but my terminal doesn't support it.
  # # http://serverfault.com/questions/23978/how-can-one-set-a-terminals-title-with-the-tput-command
  # # export PS1='$(tput tsl)\W$(tput fsl)'$PS1
  # export PS1="\[\e]0;\W\a\]"$PS1
  # ;;
# *)
  # ;;
# esac

# alias CYAN='tput setaf 6'
# alias MAGENTA='tput setaf 5'
# alias RESET='tput sgr0'

alias git=hub
alias gitx='gitx --all'
alias ls='ls -h'
alias migrate='rake db:migrate db:test:prepare'
alias screen='screen -c .screenrc'
alias ss='script/server -b 127.0.0.1'
alias v=mvim
alias rerun='AUTOTEST=true cucumber --profile rerun 2>&1 | less'
alias wip='AUTOTEST=true cucumber --profile wip 2>&1 | less'

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
