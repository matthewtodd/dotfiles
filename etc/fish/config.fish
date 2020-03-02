function chruby_auto -e fish_prompt
  set ruby_version_file "$PWD/.ruby-version"

  if test \( "$RUBY_VERSION_FILE" != $ruby_version_file \) -a \( -f $ruby_version_file \)
    set -gx RUBY_VERSION_FILE $ruby_version_file
    set desired (cat $ruby_version_file)
    string match -qe $desired $RUBY_ROOT
    if test $status -ne 0
      chruby $desired
    end
  end
end

set -x CLICOLOR yes
set -x EDITOR vim
set -x FZF_DEFAULT_COMMAND 'fd --hidden --type f'
set -x LESSHISTFILE -
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/Library/Caches
set -x XDG_DATA_HOME $HOME/Library/Application\ Support
set -x VIMINIT ":source $XDG_CONFIG_HOME/vim/vimrc"
