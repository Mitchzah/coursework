# frozen_string_literal: true

require_relative 'card'
require 'colorize'

# Map of card colors to display colors
COLOR_MAP = { red: :red, purple: :light_magenta, green: :green }.freeze

# Generates a standard 81-card deck for the game of set.
def generate_deck
  # Generate all possible combinations of card attributes
  numbers = [1, 2, 3]
  colors = %i[red purple green]
  shapes = %i[ovals diamonds squiggles]
  shadings = %i[solid striped empty]

  deck = numbers.product(colors, shapes, shadings).map do |number, color, shape, shading|
    Card.new(number, color, shape, shading)
  end
  deck.shuffle
end

# Checks if three given cards are a set
# A set is when for each attributes, the cards are all the same or different
def set?(card_one, card_two, card_three)
  attrs = [
    [card_one.number, card_two.number, card_three.number],
    [card_one.color, card_two.color, card_three.color],
    [card_one.shape, card_two.shape, card_three.shape],
    [card_one.shading, card_two.shading, card_three.shading]
  ]
  attrs.all? { |values| values.uniq.length != 2 }
end

# Shuffles the cards on the board
def shuffle_board(cards)
  cards.shuffle!
end

# Prints the current deck of cards to the user
def print_current_deck_on_board(current_board)
  puts "Your Current Board:\n".bold

  current_board.each_with_index do |card, i|
    display_color = COLOR_MAP[card.color]
    card_info = "#{card.number} #{card.color} #{card.shape} #{card.shading}"
    puts "#{i + 1}: #{card_info.colorize(display_color)}"
  end
end

# Gets and validates user input for card selection
def get_user_choice(board_size)
  loop do
    puts "Pick 3 cards (1-#{board_size}), separated by spaces (or type 'stop' to end the game):"
    input = gets.chomp.strip.downcase

    return :stop if input == 'stop'

    # Split input into array of numbers and convert to integers (0-based index)
    choices = input.split.map(&:to_i).map { |n| n - 1 }

    # Validate number of choices given
    if choices.length != 3
      puts 'Error: Please select exactly 3 cards.'
      next
    end

    # Check if all numbers are within valid range of the board
    unless choices.all? { |n| n.between?(0, board_size - 1) }
      puts "Error: Please select numbers between 1 and #{board_size}."
      next
    end

    # Check for duplicate selections
    if choices.uniq.length != 3
      puts 'Error: Please select three different cards.'
      next
    end

    return choices
  end
end

# displays how many sets the user has made
def matched_cards(matched_cards)
  num = matched_cards.length
  puts "You have made #{num} sets in total!"
end

# Replaces chosen cards on the board with new ones from the main deck
def replace_cards(board, main_deck, chosen_indices)
  chosen_indices.each do |i|
    board[i] = if main_deck.empty?
                 nil # if no cards left in the deck
               else
                 main_deck.pop
               end
  end
  board.compact! # removes nil slots if deck ran out
end

# Take 12 cards from deck, adds them to the board, and prints them out
def draw_twelve(deck)
  cards_on_board = []
  cards_on_board.push(deck.pop) while cards_on_board.length < 12 && !deck.empty?
  print_current_deck_on_board(cards_on_board) if cards_on_board.length == 12
  puts 'Last 12 cards!' if deck.empty?
  cards_on_board
end

# Returns true if there is at least one valid set in the given cards
def any_set_on_board?(board)
  board.combination(3).any? { |c1, c2, c3| set?(c1, c2, c3) }
end
