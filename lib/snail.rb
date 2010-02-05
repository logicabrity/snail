libdir = File.dirname(__FILE__)

$LOAD_PATH.unshift(libdir) unless
  $LOAD_PATH.include?(libdir) || $LOAD_PATH.include?(File.expand_path(libdir))

require 'snail/connection'
require 'snail/client'

snail = Client.new("server", 6666, "username", "pass")
snail.run
