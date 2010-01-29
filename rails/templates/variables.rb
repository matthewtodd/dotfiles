gsub_file('config/initializers/session_store.rb', /'[0-9a-f]{64,}'/, "ENV['SESSION_SECRET']")

append_file('config/preinitializer.rb', <<-END.unindent)
  require 'config/variables' if File.exists?('config/variables.rb')
END

file('config/variables.rb', <<-END.unindent)
  ENV['SESSION_SECRET'] = '#{ActiveSupport::SecureRandom.hex(64)}'
END

git(:add => 'config/initializers/session_store.rb')
git(:add => 'config/preinitializer.rb')
gitignore('config/variables.rb')

git(:commit => '-m "Use heroku-style ENV configuration."')
