HISTFILE=~/.history
HISTSIZE=1000
PROMPT='%B%~%b $vcs_info_msg_0_'
SAVEHIST=1000

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt prompt_subst
setopt share_history

bindkey -v # vi keybindings

autoload -U compinit
autoload -U vcs_info
autoload -U zmv

compinit

zstyle ':completion:*:*:git:*' commands 'base'
zstyle ':completion:*:*:git:*' verbose  'no'
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' enable git
zstyle ':vcs_info:*:prompt:*' unstagedstr   '*'
zstyle ':vcs_info:*:prompt:*' stagedstr     '+'
zstyle ':vcs_info:*:prompt:*' actionformats '%F{cyan}%b|%a%u%c%f '
zstyle ':vcs_info:*:prompt:*' formats       '%F{cyan}%b%u%c%f '
zstyle ':vcs_info:*:prompt:*' nvcsformats   ''

export CLICOLOR=yes
export EDITOR=vim
export GREP_COLOR='30;102'
export GREP_OPTIONS='--color'
export LESS='FRSX'
export PGDATA=~/.homebrew/var/postgres
export RI='--format ansi'
export RSYNC_RSH='ssh'

alias be='bundle exec'
alias ls='ls -h'

function precmd {
  vcs_info 'prompt'
}

source ~/.homebrew/Cellar/rbenv/0.2.1/completions/rbenv.zsh
