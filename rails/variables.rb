# some helper functions
class ::String
  def unindent
    gsub(/^  /, '')
  end
end

def add_sorted_line(file, line)
  append_file(file, "#{line}\n")
  run("sort -u -o #{file} #{file}")
end

# let's get going:
append_file('config/preinitializer.rb', <<-END.unindent)
  path = File.expand_path('../variables.rb', __FILE__)
  if File.exists?(path)
    load(path)
  end
END
git(:add => 'config/preinitializer.rb')

file('config/variables.rb', <<-END.unindent)
  ENV['SESSION_SECRET'] = '#{ActiveSupport::SecureRandom.hex(64)}'
END
add_sorted_line('.gitignore', 'config/variables.rb')
git(:add => '.gitignore')

gsub_file('config/initializers/session_store.rb', /'[0-9a-f]{64,}'/, "ENV['SESSION_SECRET']")
git(:add => 'config/initializers/session_store.rb')

git(:commit => '-m "Heroku-friendly environment variables."')
