require "pry"

class Board
  WINNING_SQUARE_COMBINATIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                                [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def draw
    puts ""
    puts "     |     |"
    puts "  #{square(1)}  |  #{square(2)}  |  #{square(3)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{square(4)}  |  #{square(5)}  |  #{square(6)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{square(7)}  |  #{square(8)}  |  #{square(9)}"
    puts "     |     |"
    puts ""
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def print_unmarked_keys
    size = unmarked_keys.size

    return unmarked_keys.join(", ") if size == 1

    joined_keys = unmarked_keys[0...size - 1].join(", ")

    "#{joined_keys} or #{unmarked_keys.last}"
  end

  def square(key)
    @squares[key]
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_SQUARE_COMBINATIONS.each do |combination|
      squares = @squares.values_at(*combination)
      if three_identical_markers?(squares) # => we wish this method existed
        return squares.first.marker # => return the marker, whatever it is
      end
    end

    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)

    return false if markers.size != 3

    markers.min == markers.max
  end
end

class Square
  DEFAULT_MARKER = " "

  attr_accessor :marker

  def initialize(marker = DEFAULT_MARKER)
    @marker = marker
  end

  def unmarked?
    marker == DEFAULT_MARKER
  end

  def marked?
    marker != DEFAULT_MARKER
  end

  def to_s
    marker
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class Game
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"

  attr_reader :board, :computer, :human

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_player = @human
  end

  def play
    clear_screen
    display_welcome_message

    loop do
      clear_screen_and_display_board
      player_move
      display_result

      break unless play_again?

      reset
    end

    display_goodbye_message
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?

      board.draw if @current_player == @human
    end
  end

  private

  def current_player_moves
    case @current_player
    when @human
      human_moves
      @current_player = @computer
    when @computer
      computer_moves
      @current_player = @human
    end
  end

  def reset
    board.reset
    @current_player = @human

    clear_screen

    puts "Let's play again!"
    puts ""
  end

  def clear_screen
    system "clear"
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again?"

      answer = gets.chomp

      break if %w(y n).include? answer

      puts "Sorry, must be y or n"
    end

    answer == "y"
  end

  def computer_moves
    square = board.unmarked_keys.sample

    board[square] = computer.marker
  end

  def human_moves
    puts "Choose a square between #{board.print_unmarked_keys} "

    square = nil

    loop do
      square = gets.chomp.to_i

      break if board.unmarked_keys.include?(square)

      puts "Sorry, that's not a valid choice!"
    end

    board[square] = human.marker
  end

  def print_unmarked_keys
    board.unmarked_keys
  end

  def clear_screen_and_display_board
    clear_screen
    board.draw
  end

  def display_result
    board.draw

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "The board is full!"
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe!"
  end
end

game = Game.new
game.play
