require 'irb/completion'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT_MODE] = :SIMPLE

require 'rubygems'
require 'wirble'
Wirble.init
Wirble.colorize
