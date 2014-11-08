require_relative '../repository/repository'
require_relative '../model/character'
require 'singleton'

class Characters

  include Singleton

  def initialize
    @def = Character.def
  end

  def create_character(character)
    Repository.instance.records.add(@def, sequence(character))
  end

  def all
    begin
      Repository.instance.records.get(@def)
    rescue
      empty
    end
  end

end

