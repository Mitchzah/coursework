# frozen_string_literal: true

require_relative 'card_handler'
require_relative 'prompt'

# 1. Print the game instructions
print_instructions
# 2. Generate the main deck of cards.
main_deck = generate_deck

# 3. Draw 12 cards from the main deck
cards_on_board = draw_twelve(main_deck)

# Track how many sets the user has found
sets_found = 0

# Start a timer for the user
start_time = Time.now

loop do
  # If no set exists on board, deal 3 more cards
  unless any_set_on_board?(cards_on_board)
    if main_deck.size >= 3
      3.times { cards_on_board << main_deck.pop }
      puts 'No sets available! Dealing 3 more cards...'
      print_current_deck_on_board(cards_on_board)
    else
      puts 'No sets left and deck is empty. Game over!'
      break
    end
  end
  # 4. Prompt for the user's choice (indices)
  chosen_indices = get_user_choice(cards_on_board.length)

  # If the user typed "stop", break the loop
  break if chosen_indices == :stop

  # 5. Convert indices to actual Card objects
  chosen_cards = chosen_indices.map { |i| cards_on_board[i] }

  # 6. Check if the user's choice is a set
  if set?(*chosen_cards) # or set? if you renamed it
    sets_found += 1

    # Calculate elapsed time
    elapsed_seconds = Time.now - start_time
    minutes = (elapsed_seconds / 60).to_i
    seconds = (elapsed_seconds % 60).to_i

    puts "That’s a set! You’ve found #{sets_found} set#{'s' if sets_found > 1} so far."
    puts "Time elapsed: #{minutes} minute#{'s' if minutes != 1} and #{seconds} second#{'s' if seconds != 1}."

    replace_cards(cards_on_board, main_deck, chosen_indices)
    print_current_deck_on_board(cards_on_board)
  else
    puts 'Not a set, try again.'
  end
end

# Print final stats at game end
total_elapsed = Time.now - start_time
puts "Game Over! You found #{sets_found} set#{'s' if sets_found != 1}."
puts "Total time played: #{(total_elapsed / 60).to_i} minutes and #{(total_elapsed % 60).to_i} seconds."
