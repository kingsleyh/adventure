require_relative '../game_event'

class GenericResponse

  def look(game_request)
    sequence(
      GameEvent.new(:generic, :me, "You look at something"),
      GameEvent.new(:generic, :me, "Second event"),
      # GameEvent.new(:all_in_room, "Player looks at something")
    )
  end

end