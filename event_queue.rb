require 'singleton'

class EventQueue
  include Singleton

  attr_reader :queue

  def initialize
    @queue = empty
  end

  def add(game_event)
    @queue = @queue.join(game_event)
  end

  def consume(game_event)
    @queue = @queue.reject{|ge| ge.object_id == game_event.object_id}
  end

  def drain
    @queue = empty
  end


end

