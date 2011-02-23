# vim: set filetype=sh :

setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt prompt_subst

autoload vcs_info
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '*'
zstyle ':vcs_info:*:prompt:*' stagedstr '+'
zstyle ':vcs_info:*:prompt:*' actionformats '%b%u%c|%a' ''
zstyle ':vcs_info:*:prompt:*' formats       '%b%u%c'    ''
zstyle ':vcs_info:*:prompt:*' nvcsformats   ''          ''

cdpath=${HOME}/Code

export BUNDLER_EDITOR=vim
export CLICOLOR=yes
export GREP_COLOR='30;102'
export GREP_OPTIONS='--color'
export HISTFILE=${HOME}/.history
export HISTSIZE=1000
# LESS settings ganked from git (see core.pager in git-config(1))
# Used here because they're also convenient for ri.
export LESS='FRSX' #'--quit-if-one-screen --RAW-CONTROL-CHARS --chop-long-lines --no-init'
export PATH="${HOME}/.bin:${HOME}/.homebrew/bin:${PATH}:${HOME}/.rvm/bin"
export PGDATA="${HOME}/.homebrew/var/postgres"
export PS1='%# '
export RI='--format ansi'
export RPS1='%F{magenta}$vcs_info_msg_0_%f %B%F{black}$(rvm-prompt)%f%b'
export RSYNC_RSH='ssh'
export SAVEHIST=$HISTSIZE

alias git=hub
alias ls='ls -h'

function cdruby {
  cd `ruby -rrbconfig -e 'puts Config::CONFIG["rubylibdir"]'`; ls
}

function cpgem {
  cp ${HOME}/.gem/cache/$1 $2
}

function precmd {
  # I'd like to use tput here as well, but my terminal doesn't support it.
  # http://serverfault.com/questions/23978/how-can-one-set-a-terminals-title-with-the-tput-command
  echo -ne "\e]1;$PWD:t\a" # tab title; the :t must mean "tail"?
  echo -ne "\e]2;$PWD\a"   # window title
  vcs_info 'prompt'
}

# source ${HOME}/.homebrew/etc/bash_completion
# source ${HOME}/.homebrew/Library/Contributions/brew_bash_completion.sh
source ${HOME}/.rvm/scripts/rvm

# complete -W 'ls refresh start stop' downloads
# complete -W "$(ls ${HOME}/.gem/cache/)" cpgem
# complete -C 'rake-complete' rake
