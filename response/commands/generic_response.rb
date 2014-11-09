require_relative '../game_event'

class GenericResponse

  def look(game_request)
    sequence(
      GameEvent.new(:me, "You look at something"),
      GameEvent.new(:me, "Second event"),
      # GameEvent.new(:all_in_room, "Player looks at something")
    )
  end

end