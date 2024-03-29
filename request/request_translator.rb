require_relative 'commands/generic_commands'
require_relative 'commands/login_commands'

class RequestTranslator

  def initialize(message)
    @message = message
  end

  def translate
    GenericCommands.new(@message).process
  end

end