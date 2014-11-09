class GameEvent

  attr_reader :category, :player, :response

  def initialize(category, player,response)
    @category = category
    @player = player
    @response = response
  end

end