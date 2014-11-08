require 'singleton'
require 'lazy_records'

class Repository

  include Singleton

  def initialize
    @records = MemoryRecords.new
  end

  def records
    @records
  end

end