function chruby_list
  for path in $argv
    set --append rubies (ls -A $path 2>/dev/null | sed -e s/ruby-//)
  end

  set rubies (string join0 $rubies | sort -z --version-sort | string split0)

  for ruby in $rubies
    string match -qe $ruby $RUBY_ROOT
    if test $status -eq 0
      echo " * $ruby"
    else
      echo "   $ruby"
    end
  end

  if test -z $RUBY_ROOT
    echo ' * system'
  else
    echo '   system'
  end
end

function chruby_use
  if test -n $RUBY_ROOT
    chruby_reset
  end

  for path in $argv[2..-1]
    for ruby in (ls -A $path 2>/dev/null)
      string match -qe $argv[1] $ruby
      if test $status -eq 0
        set -gx RUBY_ROOT $path/$ruby
      end
    end
  end

  if test -z $RUBY_ROOT
    echo "Could not find a ruby matching $argv[1] in:"
    chruby_list $argv[2..-1]
    return 1
  end

  set -gx --prepend PATH $RUBY_ROOT/bin
  set -gx GEM_HOME $HOME/.gem/(ruby -e 'puts "#{RUBY_ENGINE}/#{RUBY_VERSION}"')
  set -gx --prepend PATH $GEM_HOME/bin

  ruby -v
  gem env
end

function chruby_reset
  if test -z $RUBY_ROOT
    return
  end

  for i in (seq (count $PATH))
    string match -qe $RUBY_ROOT $PATH[$i]
    if test $status -eq 0
      set -e PATH[$i]
    end
  end

  for i in (seq (count $PATH))
    string match -qe $GEM_HOME $PATH[$i]
    if test $status -eq 0
      set -e PATH[$i]
    end
  end

  set -e RUBY_ROOT
  set -e GEM_HOME
end

function chruby
  set --append roots /usr/local/Cellar/ruby
  set --append roots $HOME/.rubies

  switch $argv[1]
    case '';       chruby_list $roots
    case 'system'; chruby_reset
    case '*';      chruby_use $argv[1] $roots
  end
end
