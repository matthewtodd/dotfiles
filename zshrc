HISTFILE=~/.history
HISTSIZE=1000
PROMPT='%~ $vcs_info_msg_0_'
SAVEHIST=1000

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt prompt_subst
setopt share_history

# emacs (sigh) keybindings.
# limit up-arrow search to lines starting with what I've typed.
bindkey -e
bindkey "\e[B" history-search-forward
bindkey "\e[A" history-search-backward

autoload -U compinit
autoload -U vcs_info

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
export LESS='FRSX'
export PGDATA=/usr/local/var/postgres
export RI='--format ansi'
export RSYNC_RSH='ssh'

alias be='bundle exec'
alias ls='ls -h'
alias t='todo.sh'

function precmd {
  vcs_info 'prompt'
}

source /usr/local/Cellar/rbenv/0.4.0/completions/rbenv.zsh
