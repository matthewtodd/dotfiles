# Use ~/.bashrc for things that you want around in subshells that wouldn't
# otherwise be inherited. So, aliases, completions, and functions.

alias CYAN='tput setaf 6'
alias MAGENTA='tput setaf 5'
alias RESET='tput sgr0'

alias b='bundle exec bash'
alias git='RUBYOPT= hub'
alias gitx='gitx --all'
alias ls='ls -h'
alias migrate='rake db:migrate db:test:prepare'
alias v=mvim
alias wip='rake cucumber:wip'

function __bundler_ps1 {
  if [ -n "${BUNDLE_GEMFILE-}" ]; then
    printf "${1-(%s) }" "$(dirname $BUNDLE_GEMFILE | xargs basename)"
  fi
}

function __rvm_ps1 {
  if [ $(which ruby) != '/usr/bin/ruby' ]; then
    printf "${1-(%s) }" "$(basename `rvm gemdir`)"
  fi
}

function g {
  rvm $rvm_ruby_string%$1
}

function p {
  cd ~/Code/$1; ls
}

function pg {
  cd $(gem-directory $1); ls
}

function pi {
  cd ~/Code/.inactive/$1; ls
}

function pr {
  cd `ruby -rrbconfig -e 'puts Config::CONFIG["rubylibdir"]'`; ls
}


if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

if [ -f `brew --prefix`/Library/Contributions/brew_bash_completion.sh ]; then
  . `brew --prefix`/Library/Contributions/brew_bash_completion.sh
fi

if [ -f ${HOME}/.rvm/scripts/rvm ]; then
  . ${HOME}/.rvm/scripts/rvm
fi

complete -W 'ls refresh start stop' downloads
complete -C 'gem-complete' pg
complete -W "$(ls ${HOME}/Code)" p
complete -W "$(ls ${HOME}/Code/.inactive)" pi
complete -C 'rake-complete' rake
complete -W '$(ls ${rvm_rubies_path}; echo system; echo default)' rvm
complete -W '$(for dir in `ls -d ${rvm_gems_path}/${rvm_ruby_string}%*`; do echo ${dir##*%}; done)' g
