append_file('Gemfile', <<-END.unindent)
  gem 'haml', '2.2.14'
END

run('gem bundle')

file('config/initializers/sass.rb', <<-END.unindent)
  Sass::Plugin.options[:style] = :expanded
  Sass::Plugin.options[:template_location] = Rails.root.join('app', 'views', 'layouts', 'stylesheets').to_s
END

git(:add => 'Gemfile')
git(:add => 'config/initializers/sass.rb')

git(:commit => '-m "Configure HAML."')
