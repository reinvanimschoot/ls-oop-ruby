class Player
  attr_accessor :move, :name
  attr_reader :score

  def initialize
    @score = Score.new
    @moves_history = []

    set_name
  end

  def points
    score.points
  end

  def reward_point
    score.add_point
  end

  def won?
    score.points == 10
  end

  def choose
    @moves_history << move
  end

  def print_moves_history
    return if @moves_history.empty?

    puts "#{name} has chosen the following moves:"
    @moves_history.each do |move|
      puts "- #{move.class}"
    end
  end
end

class Human < Player
  def set_name
    name = ""

    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, you must enter a value!"
    end

    self.name = name
  end

  def choose
    choice = nil

    loop do
      puts "Please choose rock, paper or scissors, spock or lizard"
      choice = gets.chomp

      break if Move::VALUES.include? choice
      puts "Woops, invalid choice!"
    end

    self.move = MOVES_MAP[choice].new

    super
  end
end

class Computer < Player
  def set_name
    self.name = ["R2D2", "Hal", "Skynet", "C3-PO"].sample
  end

  def choose
    move = Move::VALUES.sample
    self.move = MOVES_MAP[move].new

    super
  end
end

class Move
  VALUES = ["rock", "paper", "scissors", "lizard", "spock"]

  attr_reader :beats, :beat_by

  def wins_against?(move)
    beats.include? move.class
  end

  def loses_against?(move)
    beat_by.include? move.class
  end

  def to_s
    self.class
  end
end

class Rock < Move
  def initialize
    @beats = [Lizard, Scissors]
    @beat_by = [Paper, Spock]
  end
end

class Paper < Move
  def initialize
    @beats = [Rock, Spock]
    @beat_by = [Lizard, Scissors]
  end
end

class Scissors < Move
  def initialize
    @beats = [Lizard, Paper]
    @beat_by = [Rock, Spock]
  end
end

class Spock < Move
  def initialize
    @beats = [Rock, Scissors]
    @beat_by = [Paper, Lizard]
  end
end

class Lizard < Move
  def initialize
    @beats = [Paper, Spock]
    @beat_by = [Rock, Scissors]
  end
end

class Score
  attr_reader :points

  def initialize
    @points = 0
  end

  def add_point
    @points += 1
  end
end

MOVES_MAP = { "rock" => Rock, "paper" => Paper, "scissors" => Scissors, "lizard" => Lizard, "spock" => Spock }

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message

    loop do
      system("clear")

      display_score
      human.print_moves_history
      computer.print_moves_history

      human.choose
      computer.choose

      display_moves
      display_round_winner

      if series_won?
        display_series_winner
        break
      end

      break unless play_again?
    end

    display_goodbye_message
  end

  def display_round_winner
    if human.move.wins_against?(computer.move)
      handle_player_round_win(human)
    elsif human.move.loses_against?(computer.move)
      handle_player_round_win(computer)
    else
      puts "It's a tie!"
    end
  end

  def display_score
    puts " --- The score is currently ---"
    puts "#{human.name}: #{human.points}"
    puts "#{computer.name}: #{computer.points}"
    puts ""
  end

  def series_won?
    human.won? || computer.won?
  end

  def display_series_winner
    if human.won?
      puts "#{human.name} has won the series!"
    else
      puts "#{computer.name} has won the series!"
    end
  end

  def handle_player_round_win(player)
    player.reward_point
    puts "#{player.name} won this round!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move.class}."
    puts "#{computer.name} chose #{computer.move.class}."
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp

      break if ["y", "n"].include? answer.downcase
      puts "Sorry, must be y or n"
    end

    answer == "y"
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock! Goodbye!"
  end
end

RPSGame.new.play
