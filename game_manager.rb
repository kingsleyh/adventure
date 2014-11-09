require_relative 'response/response_handler'
require_relative 'event_queue'

class GameManager

  def initialize(request)
    @request = request
  end

  def game_process
    EventQueue.instance.add(@request.is_some? ? ResponseHandler.new(@request).game_process : sequence(GameEvent.new(:me, "I didn't understand that".red)))
  end

  def login_process
    EventQueue.instance.add(@request.is_some? ? ResponseHandler.new(@request).login_process : sequence(GameEvent.new(:me, "I didn't understand that".red)))
  end

end