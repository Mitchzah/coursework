# frozen_string_literal: true

# Represents a single card in the game of SET.
class Card
  def initialize(number, color, shape, shading)
    @number = number
    @color = color
    @shape = shape
    @shading = shading
  end

  attr_reader :number, :color, :shape, :shading
end
