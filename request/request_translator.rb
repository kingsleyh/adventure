require_relative 'commands/generic_commands'

class RequestTranslator

  def initialize(message)
    @message = message
  end

  def translate
    GenericCommands.new(@message).process
  end

end