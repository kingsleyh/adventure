class GameRequest

  attr_reader :category, :command, :items, :targets

  def initialize(category, command,items,targets)
    @category = category
    @command = command
    @items = items
    @targets = targets
  end

end