append_file('config/preinitializer.rb', <<-END.unindent)
  require 'vendor/bundle/environment.rb'
END

git(:add => 'config/preinitializer.rb')

git(:commit => '-m "Require bundler env."')
