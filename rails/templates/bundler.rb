append_file('config/preinitializer.rb', <<-END.unindent)
  require 'vendor/bundler/environment.rb'
END

git(:add => 'config/preinitializer.rb')

git(:commit => '-m "Require bundler env."')
