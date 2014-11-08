class Character < Record

  def initialize(name, password)
    super(name: name, password: password)
  end

  def self.def
    definition(keyword(:name), keyword(:password))
  end

end

