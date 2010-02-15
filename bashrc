# Use ~/.bashrc for things that you want around in subshells that wouldn't
# otherwise be inherited. So, aliases, completions, and functions.

alias coffee='countdown 5 "The coffee should be ready."'
alias water='countdown 42 "The water should be boiling by now."'

alias ls='ls -h'
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

if [ -f ${HOME}/.homebrew/etc/bash_completion ]; then
  . ${HOME}/.homebrew/etc/bash_completion
fi

complete -C "directory-complete ${HOME}/Code" -o default p
complete -C "directory-complete ${HOME}/Code/.inactive" -o default pi
complete -C rake-complete -o default rake
complete -W "ls refresh start stop" downloads

if [ -f ${HOME}/.homebrew/Library/Contributions/brew_bash_completion.sh ]; then
  . ${HOME}/.homebrew/Library/Contributions/brew_bash_completion.sh
fi
