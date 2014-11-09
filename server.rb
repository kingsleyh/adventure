require 'celluloid/io'
require 'totally_lazy'
require 'term/ansicolor'
require_relative 'request/request_translator'
require_relative 'request/instances/login_instance'
require_relative 'game_manager'
require_relative 'event_queue'

class String
  include Term::ANSIColor
end

class MessageHandler
  include Celluloid

  def initialize(received,instance=none)
    @request = instance.is_some? ? instance.get.new(received).translate : RequestTranslator.new(received).translate
  end

  def process
    GameManager.new(@request).process
  end

end

class Welcome
  def self.message
    "Welcome to the Awesome Game\n".yellow

  end

  def self.login_message
    "Choose an option\n".green +
        "(login) Login with existing character\n" +
        "(create) Create a new character\n"
  end
end

class GameServer
  include Celluloid::IO
  finalizer :finalize

  def initialize(host, port)
    puts "*** Starting server on #{host}:#{port}"
    @server = TCPServer.new(host, port)
    @player = none
    @clients = empty
    async.run
  end

  def finalize
    @server.close if @server
  end

  def run
    loop { async.handle_connection @server.accept }
  end

  def handle_connection(socket)
    # @clients = @clients.append(pair(player, socket))
    _, port, host = socket.peeraddr
    puts "*** Received connection from #{host}:#{port}"

    socket.write Welcome.message
    socket.write Welcome.login_message

    loop {
      input = option(socket.readpartial(4096).chomp)
      if input.is_some?
        if @player.is_some?
          MessageHandler.new(input.get).process
        else
          MessageHandler.new(input.get,LoginInstance).process
        end
        EventQueue.instance.queue.each do |game_event|
          socket.write game_event.response + "\n"
          EventQueue.instance.consume(game_event)
        end

      end
    }
      # @clients.each {|c| c.write "yay"}


  rescue EOFError
    puts "*** #{host}:#{port} disconnected"
    socket.close
  end
end

supervisor = GameServer.supervise("127.0.0.1", 1234)
trap("INT") { supervisor.terminate; exit }
sleep
