autoload -U compinit
compinit

source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

RUBIES+=(/usr/local/Cellar/ruby/*)

export CLICOLOR=yes
export EDITOR=vim
export FZF_DEFAULT_COMMAND='fd --type f'
export GIT_PS1_SHOWCOLORHINTS=yes
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GIT_PS1_SHOWUPSTREAM=verbose

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
export HISTORY_IGNORE='ls|ls *'

precmd() { __git_ps1 "%~" " " }

# https://stefan.sofa-rockers.org/2018/10/23/macos-dark-mode-terminal-vim/
alias terminal-match-system-dark-mode='osascript <<END
  tell application "System Events"
    if dark mode of appearance preferences then
      set theme to "Solarized Dark"
    else
      set theme to "Solarized Light"
    end if
  end tell

  tell application "Terminal"
    set default settings to settings set theme
    set current settings of tabs of windows to settings set theme
  end tell
END
'
