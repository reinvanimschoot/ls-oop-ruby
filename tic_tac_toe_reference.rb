class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def marker_at_square(key)
    @squares[key].marker
  end

  def print_unmarked_keys
    size = unmarked_keys.size

    return unmarked_keys.join(", ") if size == 1

    joined_keys = unmarked_keys[0...size - 1].join(", ")

    "#{joined_keys} or #{unmarked_keys.last}"
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :score

  def initialize(marker, board, player_type = :human)
    @marker = marker
    @score = 0
    @player_type = player_type
    @board = board
  end

  def move
    if human?
      puts "Choose a square (#{@board.print_unmarked_keys}): "
      square = nil
      loop do
        square = gets.chomp.to_i
        break if @board.unmarked_keys.include?(square)
        puts "Sorry, that's not a valid choice."
      end
    else
      square = calculate_computer_move
    end

    @board[square] = marker
  end

  def won_game?
    score == 5
  end

  def award_point
    @score += 1
  end

  private

  def human?
    @player_type == :human
  end

  def calculate_computer_move
    return 5 if @board.unmarked_keys.include? 5

    return find_opportunity_square if find_opportunity_square
    return find_at_risk_square if find_at_risk_square

    @board.unmarked_keys.sample
  end

  def find_opportunity_square
    Board::WINNING_LINES.each do |line|
      computer_markers, other_markers = line.partition do |key|
        @board.marker_at_square(key) == marker
      end

      if computer_markers.size == 2
        other_marker = @board.marker_at_square(other_markers.first)
        return other_markers.first if other_marker == Square::INITIAL_MARKER
      end
    end

    nil
  end

  def find_at_risk_square
    Board::WINNING_LINES.each do |line|
      human_markers, other_markers = line.partition do |key|
        marker_at_square = @board.marker_at_square(key)
        marker_at_square != marker && marker_at_square != Square::INITIAL_MARKER
      end

      if human_markers.size == 2
        other_marker = @board.marker_at_square(other_markers.first)
        return other_markers.first if other_marker == Square::INITIAL_MARKER
      end
    end

    nil
  end
end

class TTTGame
  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
  end

  def play
    clear
    display_welcome_message
    display_marker_selection

    main_game
    display_goodbye_message
  end

  private

  def main_game
    loop do
      display_board
      player_move
      display_result
      break if game_is_won?
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def game_is_won?
    human.won_game? || computer.won_game?
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_marker_selection
    marker = nil

    loop do
      puts "What marker would you like to use? Select X or O"
      marker = gets.chomp

      break if ["X", "O"].include? marker.upcase

      puts "Tha doesn't seem to be a valid choice..."
    end

    @human = Player.new(marker, @board)

    computer_marker = marker == "X" ? "O" : "X"
    @computer = Player.new(computer_marker, @board, :computer)

    @current_marker = @human.marker
  end

  def display_goodbye_message
    display_game_winner if game_is_won?

    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_game_winner
    puts ""

    if human.won_game?
      puts "Congratulations!! You won the 5-round series!"
    else
      puts "Too bad!! The computer won the 5-round series!"
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == human.marker
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    puts "Score:"
    puts "You => #{human.score}       Computer => #{computer.score}"
    puts ""
    board.draw
    puts ""
  end

  def current_player_moves
    if human_turn?
      human.move
      @current_marker = computer.marker
    else
      computer.move
      @current_marker = human.marker
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      human.award_point
      puts "You won!"
    when computer.marker
      computer.award_point
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == "y"
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    @current_marker = human.marker
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
