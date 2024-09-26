# frozen_string_literal: true

class Player
  attr_reader :name, :game_piece

  def initialize(name, game_piece)
    @name = name
    @game_piece = game_piece
  end
end