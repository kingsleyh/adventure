require 'totally_lazy'
require 'lazy_records'
require 'term/ansicolor'
require_relative 'repository/repository'
require_relative 'repository/characters'


class String
  include Term::ANSIColor
end

class Game

  def play
    start
  end

  def start
    puts 'Login with existing character (L)'
    puts 'Create a new character (C)'
    choice = wait_for(%w(C L))
    choice == 'C' ? create_character : login
  end

  def wait_for(options)
    loop do
      choice = gets.chomp
      if options.include?(choice)
        return choice
      end
      puts 'Please choose from: ' + options.join(',')
    end
  end

  def login
    puts 'Please enter character name:'
    name = gets.chomp
    puts 'Please enter password:'
    password = gets.chomp
    result = Characters.instance.all.filter(name: equals(name), password: equals(password))
    if result.empty?
      puts 'Incorrect user or password'
      puts 'Press any key to continue'
      gets
      start
    else
      puts "Successfully logged in with character: #{result.head.name}"
      puts 'Press any key to continue'
      start_game
    end
  end

  def start_game
    puts 'starting game'
    gets
  end

  def create_character
    puts 'Please create a character!'
    puts 'Please enter a name:'
    name = gets.chomp
    puts 'Please enter a password:'
    password = gets.chomp
    Characters.instance.create_character(Character.new(name, password))
    result = Characters.instance.all.filter{|r| r.name == name}
    puts result.empty? ? 'Error' : "Created character: #{result.head.name}"
    puts 'Press any key to continue'
    start_game
  end


end






