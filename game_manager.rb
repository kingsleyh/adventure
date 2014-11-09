require_relative 'response/response_handler'
require_relative 'event_queue'

class GameManager

  def initialize(request)
    @request = request
  end

  def process
    EventQueue.instance.add(@request.is_some? ? ResponseHandler.new(@request).process : sequence(GameEvent.new(:unknown, :me, "I didn't understand that".red)))
  end

end