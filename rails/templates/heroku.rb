file('lib/tasks/heroku.rake', <<-END.unindent)
  file '.heroku_gems' do
    require 'open-uri'

    open('http://installed-gems.heroku.com') do |stream|
      open('.heroku_gems', 'w') do |file|
        file.write(stream.read)
      end
    end
  end

  file '.gems' => ['Gemfile', '.heroku_gems'] do
    heroku_gems = Hash.new([])

    open('.heroku_gems').read.scan(/<li>(\S+?) \((.+?)\)<\/li>/) do |match|
      name     = match.first
      versions = match.last.split(/, ?/)

      heroku_gems[name] = versions
    end

    class Gemfile
      def initialize(path='Gemfile')
        @gems = {}
        instance_eval(File.read(path))
      end

      def each(&block)
        @gems.each(&block)
      end

      def gem(name, version, options={})
        if version.nil?
          abort("Please specify a version for \#{name}.")
        end

        @gems[name] = version
      end

      private

      def method_missing(*args)
        # since we instance_eval, just swallow messages we don't care about
      end
    end

    open('.gems', 'w') do |file|
      Gemfile.new.each do |name, version|
        next if heroku_gems[name].include?(version)
        file.puts "\#{name} --version '\#{version}'"
      end
    end

    puts File.read('.gems')
  end
END

gitignore('.heroku_gems')
git(:add => 'lib/tasks/heroku.rake')
git(:commit => '-m "Support generating a .gems file for Heroku."')

