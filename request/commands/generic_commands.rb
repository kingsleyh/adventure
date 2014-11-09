require_relative 'commands'
require_relative '../../request/game_request'

class GenericCommands < Commands

  def initialize(message)
    @message = message
  end

  def process
    r = condition(/^(l|look)$/i) do |with|
      GameRequest.new(:look,none,none) unless with.nil?
    end

    r
  end

end