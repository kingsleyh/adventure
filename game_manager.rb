class GameManager

  def initialize(request)
    @request = option(request)
  end

  def response
    @request.is_some? ?
    some("got here ok with request: #{@request.command}") :
    some("I didn't understand that")
  end

end