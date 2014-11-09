require_relative 'commands/login_commands'

class LoginInstance

  def initialize(message)
    @message = message
  end

  def translate
    LoginCommands.new(@message).process
  end

end