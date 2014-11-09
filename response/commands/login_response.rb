require_relative '../game_event'

class LoginResponse

    def login(game_request)
      sequence(
        GameEvent.new(:me, "So you want to login huh?"),
      )
    end

end