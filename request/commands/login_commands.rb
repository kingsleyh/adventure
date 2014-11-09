require_relative 'commands'
require_relative '../../request/game_request'

class LoginCommands < Commands

  def initialize(message)
    @message = message
  end

  def process
    r = condition(/^(login)$/i) do |with|
      GameRequest.new(:login,:login,none,none) unless with.nil?
    end

    option(r)
  end

end