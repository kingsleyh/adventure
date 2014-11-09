class GameRequest

  attr_reader :command, :items, :targets

  def initialize(command,items,targets)
    @command = command
    @items = items
    @targets = targets
  end

end