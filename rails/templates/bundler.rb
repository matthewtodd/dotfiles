file('Gemfile', <<-END.unindent)
  bundle_path 'vendor/bundler'

  gem 'rails',          '2.3.5', :bundle => false
  gem 'actionmailer',   '2.3.5', :bundle => false
  gem 'actionpack',     '2.3.5', :bundle => false
  gem 'activerecord',   '2.3.5', :bundle => false
  gem 'activeresource', '2.3.5', :bundle => false
  gem 'activesupport',  '2.3.5', :bundle => false
  gem 'rack',           '1.0.1', :bundle => false
  gem 'rake',           '0.8.7', :bundle => false
END

run('gem bundle')

append_file('config/preinitializer.rb', <<-END.unindent)
  require 'vendor/bundler/environment.rb'
END

git(:add => 'Gemfile')
gitignore('bin')
git(:add => 'config/preinitializer.rb')
git(:add => 'vendor/bundler')

git(:commit => '-m "Set up bundler."')
