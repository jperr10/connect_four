# frozen_string_literal: true

require_relative 'game.rb'
require_relative 'grid.rb'
require_relative 'player.rb'

def play_game
  game = Game.new
  game.play
  repeat_game
end

def repeat_game
  puts "\nWould you like to play again? Type 'y' for yes or 'n' for no."
  repeat_input = gets.chomp.downcase
  if repeat_input == 'y'
    play_game
  else
    puts 'Thanks for playing!'
  end
end

play_game