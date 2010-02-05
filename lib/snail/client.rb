require 'observer'
require 'thread'
require 'readline'

class Client
  def initialize(server, port, user, password)
    @connection = Connection.new(server, port)
    @connection.add_observer(self)
    register_connection(user, password)
  end
  
  def send message
    puts "SENT: " +  message
    @connection.send message
  end
  
  def register_connection(user, password)
    send "PASS " + password
    send "NICK " + user
    send "USER " + user + " 0 * :" + user
  end
  
  def get_user_input
    loop do
      line = Readline.readline('', true)
      send line
    end
  end

  def update message
    puts message
  end
  
  def run
    output = Thread.new { @connection.listen }
    input  = Thread.new { get_user_input }
    output.join
  end
end
