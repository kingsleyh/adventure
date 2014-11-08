# require_relative 'game'
# require 'concurrent'
#
# class Server
#
#   def initialize
#     game = Game.new
#     loop do
#       game.play
#       Concurrent::Future.execute{ sleep 20 ; puts "woop" }
#     end
#   end
#
# end
#
#
# Server.new

require 'celluloid/io'
require 'totally_lazy'

class MessageHandler
  include Celluloid

  def initialize(received)
    @received = received.chomp
    p @received
  end

  def translate
    if @received.match(/sit down/)
      some("you sit down..\n")
    else
      none
    end
  end

end


class EchoServer
  include Celluloid::IO
  finalizer :finalize

  def initialize(host, port)
    puts "*** Starting server on #{host}:#{port}"
    @server = TCPServer.new(host, port)
    @clients = []
    async.run
  end

  def finalize
    @server.close if @server
  end

  def run
    loop { async.handle_connection @server.accept }
  end

  def handle_connection(socket)
    @clients << socket
    _, port, host = socket.peeraddr
    puts "*** Received connection from #{host}:#{port}"
    loop {

      response = MessageHandler.new(socket.readpartial(4096)).translate
      socket.write response.get if response.is_some?
      # socket.write socket.readpartial(4096)
      @clients.each {|c| c.write "yay"}


    }
  rescue EOFError
    puts "*** #{host}:#{port} disconnected"
    socket.close
  end
end

supervisor = EchoServer.supervise("127.0.0.1", 1234)
trap("INT") { supervisor.terminate; exit }
sleep
