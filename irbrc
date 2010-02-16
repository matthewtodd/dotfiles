require 'irb/completion'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT_MODE] = :SIMPLE

begin
  require 'rubygems'
  require 'wirble'
rescue LoadError
  puts 'You may want to add "gem \'wirble\'" to your Gemfile.'
else
  Wirble.init
  Wirble.colorize
end
