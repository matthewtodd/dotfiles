# Use ~/.bashrc for things that you want around in subshells that wouldn't
# otherwise be inherited. So, aliases, completions, and functions.

alias CYAN='tput setaf 6'
alias MAGENTA='tput setaf 5'
alias RESET='tput sgr0'

alias b='bundle exec bash'
alias git='RUBYOPT= hub'
alias gitx='gitx --all'
alias ls='ls -h'
alias man='gem man --system'
alias migrate='rake db:migrate db:test:prepare'
alias ss='script/server -b 127.0.0.1'
alias v=mvim
alias wip='rake cucumber:wip'

function __bundler_ps1 {
  if [ -n "${BUNDLE_GEMFILE-}" ]; then
    printf "${1-(%s) }" "$(dirname $BUNDLE_GEMFILE | xargs basename)"
  fi
}

function __rvm_ps1 {
  if [ -n "${rvm_ruby_gem_home}" ]; then
    printf "${1-(%s) }" "$(basename $rvm_ruby_gem_home)"
  fi
}

function cg {
  cp ${rvm_gems_cache_path}/$1 $2
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
complete -W "$(ls ${HOME}/.rvm/gems/cache)" cg
complete -C 'gem-complete' pg
complete -C 'rake-complete' rake
