class Commands

  def condition(expression)
    yield @message.match(expression)
  end

end