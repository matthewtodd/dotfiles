class ::String
  def unindent
    gsub(/^  /, '')
  end
end

def append_sentinel(file, sentinel, data)
  gsub_file(file, /(#{Regexp.escape(sentinel)})/mi) do |match|
    "#{match}\n#{data}"
  end
end

def gitignore(pattern)
  append_file('.gitignore', "#{pattern}\n")
  run("sort -u -o .gitignore .gitignore")
  git(:add => '.gitignore')
end

%w(
  basic.rb
  bundler.rb
  cucumber.rb
  testing.rb
  variables.rb
).map do |file|
  File.join(ENV['HOME'], '.rails', 'templates', file)
end.each do |file|
  load_template(file)
end
