require 'rubygems'
require 'hirb'
require 'wirble'

Wirble.init
Wirble.colorize

Hirb.enable

def tell_hirb_the_screen_resized
  Hirb::View.resize
end

IRB.conf[:AUTO_INDENT] = true

# Trimmed-down version of
# http://plasti.cx/2009/09/30/more-about-logging-directly-to-script-console
if ENV['RAILS_ENV']
  def show_me_the_logs_thanks
    logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = logger
    ActionController::Base.logger = logger
    ActiveRecord::Base.clear_all_connections!
    true # just so I don't see AR::Base.inspect
  end
end

