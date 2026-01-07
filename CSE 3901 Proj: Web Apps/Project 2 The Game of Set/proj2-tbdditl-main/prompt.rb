# frozen_string_literal: true

# A constant string with the game instructions
INSTRUCTIONS_TEXT = <<~INSTRUCTIONS
  Welcome to the game of SET! :D

  Goal of the Game:
    Find as many 'Sets' as possible from the cards on the table.

  Rules:
    1. Each card has 4 features: color, shape, number, and shading.
    2. 81 total cards in each game. 27 possible Sets.
    3. Each feature has 3 possible options (e.g., red, green, purple).
    4. A SET is 3 cards where, for every feature, they are ALL the same OR ALL different.
    5. 12 cards are dealt face-up. Players race to find Sets among them.
    6. The player with the most Sets at the end wins!

INSTRUCTIONS

def print_instructions
  puts INSTRUCTIONS_TEXT
end
