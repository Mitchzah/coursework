# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'card_handler'

# Unit tests for card_handler.rb
class TestCardHandler < Minitest::Test
  def setup
    @deck = generate_deck
    @card1 = Card.new(1, :red, :ovals, :solid)
    @card2 = Card.new(2, :purple, :diamonds, :striped)
    @card3 = Card.new(3, :green, :squiggles, :empty)
  end

  # Test uniqueness of cards
  def test_generate_deck
    deck = generate_deck
    assert_equal 81, deck.length, 'Deck should have 81 cards'

    unique_cards = deck.uniq { |card| [card.number, card.color, card.shape, card.shading] }
    assert_equal 81, unique_cards.length, 'All cards in deck should be unique'
  end

  # Test a valid set where all attributes are different
  def test_set_with_all_different
    assert set?(@card1, @card2, @card3), 'Should be a valid set with all different attributes'
  end

  # Test a valid set where all attributes are the same
  def test_set_with_all_same
    card1 = Card.new(1, :red, :ovals, :solid)
    card2 = Card.new(1, :red, :ovals, :solid)
    card3 = Card.new(1, :red, :ovals, :solid)
    assert set?(card1, card2, card3), 'Should be a valid set with all same attributes'
  end

  # Test an invalid set
  def test_invalid_set
    card1 = Card.new(1, :red, :ovals, :solid)
    card2 = Card.new(1, :red, :diamonds, :striped)
    card3 = Card.new(1, :purple, :diamonds, :striped)
    refute set?(card1, card2, card3), 'Should not be a valid set'
  end

  # Test that the board shuffles correctly and maintains the same cards, just in different order
  def test_shuffle_board
    original_cards = [
      Card.new(1, :red, :ovals, :solid),
      Card.new(2, :purple, :diamonds, :striped),
      Card.new(3, :green, :squiggles, :empty)
    ]
    copied_cards = original_cards.dup
    shuffle_board(copied_cards)

    # Check that both boards have the same number of cards
    assert_equal original_cards.length, copied_cards.length, 'Shuffled board should have same number of cards'
    # Check that both boards have the same cards, when sorted
    assert_equal original_cards.sort_by(&:number), copied_cards.sort_by(&:number)
  end

  # Test board with a valid set
  def test_set_on_board_valid
    board_with_set = [
      @card1, @card2, @card3,
      Card.new(1, :red, :ovals, :striped),
      Card.new(2, :purple, :diamonds, :empty),
      Card.new(3, :green, :squiggles, :solid)
    ]
    assert any_set_on_board?(board_with_set), 'Should find at least one set on board'
  end

  # Test board with a invalid set
  def test_set_on_board_invalid
    board_with_set = [
      Card.new(1, :purple, :ovals, :striped),
      Card.new(2, :purple, :diamonds, :empty),
      Card.new(3, :green, :squiggles, :solid)
    ]
    refute any_set_on_board?(board_with_set), 'Should find no set on board'
  end

  # Test replacing cards on the board with cards from the main deck
  def test_replace_cards
    board = [@card1, @card2, @card3]
    main_deck = generate_deck
    original_deck_size = main_deck.length

    replace_cards(board, main_deck, [0, 1])

    assert_equal original_deck_size - 2, main_deck.length, 'Should remove 2 cards from main deck'
    assert_equal 3, board.length, 'Board should maintain its size'
  end

  # Test drawing twelve cards from the main deck
  def test_draw_twelve
    deck = generate_deck
    original_deck_size = deck.length

    board = draw_twelve(deck)

    assert_equal 12, board.length, 'Should draw exactly 12 cards'
    assert_equal original_deck_size - 12, deck.length, 'Should remove 12 cards from deck'
  end
end
