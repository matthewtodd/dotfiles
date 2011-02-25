# vim: set filetype=sh :

setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt prompt_subst

autoload -U vcs_info
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' enable git
zstyle ':vcs_info:*:prompt:*' unstagedstr   '*'
zstyle ':vcs_info:*:prompt:*' stagedstr     '+'
zstyle ':vcs_info:*:prompt:*' actionformats '%F{magenta}(%b|%a)%u%c%f '
zstyle ':vcs_info:*:prompt:*' formats       '%F{magenta}(%b)%u%c%f '
zstyle ':vcs_info:*:prompt:*' nvcsformats   '%# '

autoload -U compinit
compinit

cdpath=( ${HOME}/Code ${HOME}/Documents/Projects )

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
export PS1='$vcs_info_msg_0_'
export RI='--format ansi'
export RPS1='%B%F{black}$(rvm-prompt)%f%b'
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

function chpwd {
  # I'd like to use tput here as well, but my terminal doesn't support it.
  # http://serverfault.com/questions/23978/how-can-one-set-a-terminals-title-with-the-tput-command
  print -Pn "\e]1;%1~\a" # tab title
  print -Pn "\e]2;%~\a"  # window title
}

chpwd

function precmd {
  vcs_info 'prompt'
}

source ${HOME}/.rvm/scripts/rvm

# TODO compctl has been replaced by a new completion system:
# http://zsh.sourceforge.net/Doc/Release/zsh_19.html
compctl -k '(ls refresh start stop)' downloads
compctl -k "($(ls ${HOME}/.gem/cache/))" cpgem
