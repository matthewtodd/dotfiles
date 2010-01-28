file('Gemfile', <<-END.unindent)
  bundle_path 'vendor/bundler'

  gem 'rails', '2.3.5'
END

run('gem bundle')

append_file('config/preinitializer.rb', <<-END.unindent)
  require 'vendor/bundler/environment.rb'
END

git(:add => 'Gemfile')
git(:add => 'config/preinitializer.rb')
gitignore('bin')
gitignore('vendor/bundler')

git(:commit => '-m "Set up bundler."')
