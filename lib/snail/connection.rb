require "observer"
require "socket"
require 'thread'

class Connection
  include Observable

  def initialize(server, port)
    @socket = TCPSocket.open(server, port)
    @lock   = Mutex.new
  end

  def send message
    @lock.synchronize do 
      @socket.print message + "\r\n"
    end
  end

  def listen
    loop do
      r,w,e = select([@socket], nil, nil, 1)
      break if @socket.eof
      if r != nil
        changed(true) # Observable
        @lock.synchronize do
          output = @socket.readline.chomp
          notify_observers output # sets changed to false
        end
      end
    end
    @socket.close
  end
end
