rake('db:migrate')

gitignore('db/*.sqlite3*')
gitignore('log/*')
gitignore('tmp/**/*')
git(:add => '.')
git(:commit => '-m "Generate rails app."')

%w(
  README
  config/initializers/backtrace_silencers.rb
  config/initializers/inflections.rb
  config/initializers/mime_types.rb
  doc/README_FOR_APP
  public/images
  public/index.html
  public/javascripts
  test/performance
).each do |file|
  git(:rm => "-r #{file}")
end

%w(
  Rakefile
  app/controllers/application_controller.rb
  app/helpers/application_helper.rb
  config/environment.rb
  config/environments/development.rb
  config/environments/test.rb
  config/environments/production.rb
  config/initializers/new_rails_defaults.rb
  config/initializers/session_store.rb
  config/routes.rb
  test/test_helper.rb
).each do |file|
  gsub_file(file, /\s*#.*$/, '') # strip comments
  gsub_file(file, /^\s*$\n/, '') # squash blank lines
  gsub_file(file, '"', "'")      # prefer single quotes
  git(:add => file)
end

git(:commit => '-m "Clean up rails cruft."')

run('find . -type d -empty -delete')
