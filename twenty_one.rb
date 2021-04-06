class Deck
  FACE_CARD_VALUES = { Jack: 10, Queen: 10, King: 10, Ace: 11 }

  def initialize
    reset
  end

  def deal(amount = 1)
    @cards.pop(amount)
  end

  def reset
    @cards = ((2..10).to_a + [:Jack, :Queen, :King, :Ace]) * 4
    @cards.shuffle!
  end
end

class Participant
  attr_reader :hand

  def initialize
    @hand = []
  end

  def add_cards_to_hand(cards)
    @hand += cards
  end

  def total_hand_value
    total_hand_value = 0

    number_cards, face_cards = divide_card_types

    total_hand_value += number_cards.sum

    calculate_face_cards(face_cards, total_hand_value)
  end

  def bust?
    total_hand_value > 21
  end

  def clear_hand
    @hand = []
  end

  private

  def divide_card_types
    @hand.partition do |card|
      card.instance_of?(Integer)
    end
  end

  def calculate_face_cards(face_cards, total_hand_value)
    face_cards.each do |face_card|
      total_hand_value += Deck::FACE_CARD_VALUES[face_card]

      if face_card == :Ace && total_hand_value > 21
        total_hand_value -= 10
      end
    end

    total_hand_value
  end
end

class Game
  def initialize
    @deck = Deck.new

    @player = Participant.new
    @dealer = Participant.new

    @turn = :player
  end

  def play
    display_welcome_message

    main_game_loop
  end

  private

  def display_welcome_message
    puts "Welcome to Blackjack!"
    puts ""
  end

  def main_game_loop
    loop do
      deal_initial_cards

      display_hands(clear_screen: true)

      player_turn
      break handle_player_bust if @player.bust?

      dealer_turn
      break handle_dealer_bust if @dealer.bust?

      compare_hands

      break unless play_again?

      reset_game_state
    end
  end

  def deal_initial_cards
    @player.add_cards_to_hand(@deck.deal(2))
    @dealer.add_cards_to_hand(@deck.deal(2))
  end

  def display_hands(clear_screen: false)
    system "clear" if clear_screen

    puts "------------------------------------------"
    puts show_dealer_hand
    puts ""
    puts "You have #{@player.hand.join(" and ")}"
    puts (@player.total_hand_value)
    puts "------------------------------------------"
  end

  def player_turn
    loop do
      choice = player_chooses

      case choice
      when "h"
        @player.add_cards_to_hand(@deck.deal)
      when "s"
        @turn = :dealer
        break
      end

      display_hands(clear_screen: true)

      break if @player.bust?
    end
  end

  def show_dealer_hand
    if @turn == :player
      "The dealer has #{@dealer.hand[0]} and an unknown card."
    else
      "The dealer has #{@dealer.hand.join(" and ")}"
    end
  end

  def handle_player_bust
    puts ""
    puts "You busted! The dealer wins!"
  end

  def handle_dealer_bust
    puts ""
    puts "The dealer busted! you win!!"
  end

  def compare_hands
    puts "The dealer stayed at #{@dealer.total_hand_value}..."
    puts "You stayed at #{@player.total_hand_value}..."
    puts ""

    if @player.total_hand_value > @dealer.total_hand_value
      puts "You won!!"
    elsif @player.total_hand_value < @dealer.total_hand_value
      puts "The dealer wins!!"
    else
      puts "It's a tie!!"
    end
  end

  def dealer_turn
    loop do
      break if @dealer.total_hand_value >= 17

      @dealer.add_cards_to_hand(@deck.deal)
    end

    display_hands(clear_screen: true)
  end

  def player_chooses
    loop do
      puts ""
      puts "What you like to do?"
      puts "- (H) Hit"
      puts "- (S) Stay"
      puts ""

      choice = gets.chomp.downcase

      break choice if ["h", "s"].include? choice
      puts "Hm... That doesn't seem like a valid choice..."
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

  def reset_game_state
    @deck.reset
    @player.clear_hand
    @dealer.clear_hand
    @turn = :player
  end
end

Game.new.play
