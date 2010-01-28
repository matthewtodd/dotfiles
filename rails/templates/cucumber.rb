append_file('Gemfile', <<-END.unindent)

  only(:cucumber) do
    gem 'cucumber-rails',   '0.2.3', :require_as => false
    gem 'database_cleaner', '0.2.3', :require_as => false
    gem 'webrat',           '0.6.0', :require_as => false
  end
END

run('gem bundle')

generate(:cucumber, '--testunit', '--webrat')

gsub_file('config/environments/cucumber.rb', /^.*config.gem .*$\n/, '')

git(:add => 'Gemfile')
git(:add => 'config/cucumber.yml')
git(:add => 'config/database.yml')
git(:add => 'config/environments/cucumber.rb')
git(:add => 'features')
git(:add => 'lib/tasks/cucumber.rake')
gitignore('rerun.txt')
git(:add => 'script/cucumber')

git(:commit => '-m "Set up cucumber."')

