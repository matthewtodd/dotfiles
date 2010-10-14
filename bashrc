# Use ~/.bashrc for things that you want around in subshells that wouldn't
# otherwise be inherited. So, aliases, completions, and functions.

alias CYAN='tput setaf 6'
alias MAGENTA='tput setaf 5'
alias RESET='tput sgr0'

alias c=clear
alias git=hub
alias gitx='gitx --all'
alias ls='ls -h'
alias migrate='rake db:migrate db:test:prepare'
alias screen='screen -c .screenrc'
alias ss='script/server -b 127.0.0.1'
alias v=mvim
alias wip='clear; AUTOTEST=true rake cucumber:wip 2>&1 | less'

function __rvm_ps1 {
  if [ -x "${HOME}/.rvm/bin/rvm-prompt" ]; then
    printf "${1-(%s) }" "$(${HOME}/.rvm/bin/rvm-prompt v g s)"
  fi
}

function cg {
  cp ${HOME}/.gem/cache/$1 $2
}

function pg {
  cd $(gem-directory $1); ls
}

function pr {
  cd `ruby -rrbconfig -e 'puts Config::CONFIG["rubylibdir"]'`; ls
}

source ${HOME}/.homebrew/etc/bash_completion
source ${HOME}/.homebrew/Library/Contributions/brew_bash_completion.sh
source ${HOME}/.rvm/scripts/rvm

complete -W 'ls refresh start stop' downloads
complete -W "$(ls ${HOME}/.gem/cache/)" cg
complete -C 'gem-complete' pg
complete -C 'rake-complete' rake
