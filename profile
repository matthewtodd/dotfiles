# vim: set filetype=sh :
alias coffee='countdown 5 "The coffee should be ready."'
alias water='countdown 42 "The water should be boiling by now."'

alias ls='ls -Gh'
alias git=hub
alias migrate='rake db:migrate db:test:prepare'
alias rails='generate-rails-app'
alias ri='ri --system'
alias sc='script/console'
alias ss='script/server'
alias v=mvim
alias wip='rake cucumber:wip'

function p {
  cd ~/Code/$1; ls
}

function pi {
  cd ~/Code/.inactive/$1; ls
}

# histappend and HIST* envars from
# http://blog.macromates.com/2008/working-with-history-in-bash/
shopt -s histappend

if [ -f ${HOME}/.homebrew/etc/bash_completion ]; then
  . ${HOME}/.homebrew/etc/bash_completion
fi

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
export PS1='\w\[\033[35m\]$(__git_ps1 " %s")\[\033[0m\] '
export RSYNC_RSH='ssh'

case "$TERM" in
xterm*|rxvt*)
  export PS1="\[\033]0;\W\007\]${PS1}"
  ;;
*)
  ;;
esac

complete -C "directory-complete ${HOME}/Code" -o default p
complete -C "directory-complete ${HOME}/Code/.inactive" -o default pi
complete -C rake-complete -o default rake
complete -W "ls refresh start stop" downloads

if [ -f ${HOME}/.homebrew/Library/Contributions/brew_bash_completion.sh ]; then
  . ${HOME}/.homebrew/Library/Contributions/brew_bash_completion.sh
fi
