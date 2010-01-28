append_file('Gemfile', <<-END.unindent)

  only(:cucumber) do
    gem 'cucumber-rails',   '0.2.3', :require_as => false
    gem 'database_cleaner', '0.2.3', :require_as => false
    gem 'webrat',           '0.6.0', :require_as => false
  end

  only(:test) do
    gem 'faker',     '0.3.1'
    gem 'machinist', '1.0.6', :require_as => 'machinist/active_record'
    gem 'shoulda',   '2.10.2'
  end
END

file('test/blueprints.rb')

append_sentinel('test/test_helper.rb', "require 'test_help'", <<-END.unindent)
  require File.expand_path(File.dirname(__FILE__) + '/blueprints')
END

gsub_file('test/test_helper.rb', /^.*fixtures.*$\n/, '')

git(:add => 'Gemfile')
git(:add => 'test/blueprints.rb')
git(:add => 'test/test_helper.rb')

git(:commit => '-m "Set up test libraries."')
