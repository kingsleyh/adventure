class GameEvent

  attr_reader :player, :response

  def initialize(player,response)
    @player = player
    @response = response
  end

end