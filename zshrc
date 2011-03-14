# History
HISTSIZE=1000 # in-memory history size
SAVEHIST=1000 # in-file history size
HISTFILE=~/.history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt share_history

# Prompt
PROMPT='$vcs_info_msg_0_'
RPROMPT='%F{cyan}$(rvm-prompt)%f'
setopt prompt_subst

# Pushd
DIRSTACKSIZE=20
setopt auto_pushd
setopt pushd_ignore_dups

# vi keybindings
bindkey -v

autoload -U vcs_info
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' enable git
zstyle ':vcs_info:*:prompt:*' unstagedstr   '*'
zstyle ':vcs_info:*:prompt:*' stagedstr     '+'
zstyle ':vcs_info:*:prompt:*' actionformats '%F{magenta}(%b|%a)%u%c%f '
zstyle ':vcs_info:*:prompt:*' formats       '%F{magenta}(%b)%u%c%f '
zstyle ':vcs_info:*:prompt:*' nvcsformats   '%# '

cdpath=( ~/Code ~/Documents )
fpath=( ~/.zsh/functions $fpath )
path=( ~/.bin ~/.homebrew/bin $path ~/.rvm/bin )

autoload -U compinit
compinit
zstyle ':completion:*:*:git:*' commands 'base'
zstyle ':completion:*:*:git:*' verbose  'no'

autoload -U zmv

export CLICOLOR=yes
export EDITOR=vim
export GREP_COLOR='30;102'
export GREP_OPTIONS='--color'
# LESS settings ganked from git (see core.pager in git-config(1))
# Used here because they're also convenient for ri.
export LESS='FRSX' #'--quit-if-one-screen --RAW-CONTROL-CHARS --chop-long-lines --no-init'
export PGDATA=~/.homebrew/var/postgres
export RI='--format ansi'
export RSYNC_RSH='ssh'

# TODO learn about zsh's correction facilities.
alias gerp=grep
alias ls='ls -h'

function cdruby {
  cd `ruby -rrbconfig -e 'puts Config::CONFIG["rubylibdir"]'`; ls
}

function cpgem {
  cp ~/.gem/cache/$1 $2
}

function chpwd {
  # I'd like to use tput here as well, but my terminal doesn't support it.
  # http://serverfault.com/questions/23978/how-can-one-set-a-terminals-title-with-the-tput-command
  print -Pn "\e]1;%1~\a" # tab title
  print -Pn "\e]2;%~\a"  # window title
}

chpwd

function git {
  hub "$@"
}

function precmd {
  vcs_info 'prompt'
}

source ~/.rvm/scripts/rvm

# TODO compctl has been replaced by a new completion system:
# http://zsh.sourceforge.net/Doc/Release/zsh_19.html
compctl -k '(ls refresh start stop)' downloads
compctl -k "($(ls ~/.gem/cache/))" cpgem
