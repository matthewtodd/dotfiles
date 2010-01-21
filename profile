# vim: set filetype=sh :
alias coffee='countdown 5 "The coffee should be ready."'
alias water='countdown 42 "The water should be boiling by now."'

alias ls='ls -Gh'
alias git=hub
alias migrate='rake db:migrate db:test:prepare'
alias rails='rails -m ~/.rails/template.rb'
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

function __current_directory__ {
  echo ${PWD} | sed -e 's|^.*/||'
}

function __git_dirty_indicator__ {
  git status 2> /dev/null | tail -n1 | grep -q "working directory clean" || echo "*"
}

function __git_branch__ {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ \1$(__git_dirty_indicator__)/"
}

# histappend and HIST* envars from Actiontastic guy,
# http://blog.macromates.com/2008/working-with-history-in-bash/
shopt -s histappend

export EDITOR=vim
export GEM_OPEN_EDITOR=mvim
export GREP_COLOR='30;102'
export GREP_OPTIONS='--color'
export HISTCONTROL=erasedups
export HISTSIZE=1000
export PATH="${HOME}/.bin:${HOME}/.gem/ruby/1.8/bin:${HOME}/.homebrew/bin:${PATH}"
export PS1='[\h:\w\[\033[35m\]$(__git_branch__)\[\033[0m\]] \[\033[1;34m\]\u\[\033[0m\]\\$ '
export RSYNC_RSH='ssh'

case "$TERM" in
xterm*|rxvt*)
  export PROMPT_COMMAND='echo -ne "\033]0;$(__current_directory__)\007"'
  ;;
*)
  ;;
esac

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

complete -C "directory-complete ${HOME}/Code" -o default p
complete -C "directory-complete ${HOME}/Code/.inactive" -o default pi
complete -C rake-complete -o default rake
complete -C 'tabtab --gem matthewtodd-downloads' -o default downloads
