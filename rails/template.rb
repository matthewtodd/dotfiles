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

Dir.glob("#{ENV['HOME']}/.rails/templates/*.rb").each do |path|
  load_template(path)
end

