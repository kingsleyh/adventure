require_relative '../response/commands/generic_response'
require_relative '../response/commands/login_response'

class ResponseHandler

  def initialize(game_request)
    @game_request = game_request
  end

  def process
    Object.const_get(@game_request.get.category.to_s.capitalize + 'Response').new.send(@game_request.get.command, @game_request)
  end

end