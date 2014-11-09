require 'celluloid/io'
require 'totally_lazy'
require 'term/ansicolor'
require_relative 'request/request_translator'
require_relative 'game_manager'
require_relative 'event_queue'

class String
  include Term::ANSIColor
end

class MessageHandler
  include Celluloid

  def initialize(received)
    @request = RequestTranslator.new(received).translate
  end

  def game_process
    GameManager.new(@request).game_process
  end

  def login_process
    GameManager.new(@request).login_process
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

  def process_game_commands(socket)
    input = option(socket.readpartial(4096).chomp)
    if input.is_some?
      MessageHandler.new(input.get).game_process

      EventQueue.instance.queue.each do |game_event|
        socket.write game_event.response + "\n"
        EventQueue.instance.consume(game_event)
      end
    end
  end

  def login_or_create_player(socket)
    input = option(socket.readpartial(4096).chomp)
    if input.is_some?
      MessageHandler.new(input.get).login_process

      EventQueue.instance.queue.each do |game_event|
        socket.write game_event.response + "\n"
        EventQueue.instance.consume(game_event)
      end
    end
  end

  def handle_connection(socket)
    # @clients = @clients.append(pair(player, socket))
    _, port, host = socket.peeraddr
    puts "*** Received connection from #{host}:#{port}"

    socket.write Welcome.message
    socket.write Welcome.login_message

    p @player.is_some?
    loop {
      if @player.is_some?
        process_game_commands(socket)
      else
        login_or_create_player(socket)
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
