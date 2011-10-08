# History
HISTSIZE=1000 # in-memory history size
SAVEHIST=1000 # in-file history size
HISTFILE=~/.history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt share_history

# Prompt
PROMPT='%B%F{black}%~%f%b $vcs_info_msg_0_'
RPROMPT='%B%F{black}%t%F%b'
setopt prompt_subst

# vi keybindings
bindkey -v

autoload -U vcs_info
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' enable git
zstyle ':vcs_info:*:prompt:*' unstagedstr   '*'
zstyle ':vcs_info:*:prompt:*' stagedstr     '+'
zstyle ':vcs_info:*:prompt:*' actionformats '%F{cyan}%b|%a%u%c%f '
zstyle ':vcs_info:*:prompt:*' formats       '%F{cyan}%b%u%c%f '
zstyle ':vcs_info:*:prompt:*' nvcsformats   ''

cdpath=( ~/Code )
fpath=( ~/.zsh/functions $fpath )
path=( ~/.bin ~/.homebrew/bin $path )

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

function precmd {
  vcs_info 'prompt'
}

eval "$(rbenv init -)"
