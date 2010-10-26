require 'irb/completion'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT_MODE] = :SIMPLE

require 'rubygems'

begin
  require 'wirble'
rescue LoadError
  # No worries, it's just not in this gemset.
else
  Wirble.init
  Wirble.colorize
end
