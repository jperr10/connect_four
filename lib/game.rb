# frozen_string_literal: true

class Game
  attr_reader :first_player, :second_player, :grid, :current_player

  def initialize
    @first_player = nil
    @second_player = nil
    @grid = Grid.new
    @current_player = nil
  end

  def play
    game_set_up
    grid.show
    take_turns
    conclusion
  end

  def create_player(number, game_piece)
    puts "\nPlayer #{number} will use '#{game_piece}' as their game piece."
    puts "What's the name for player #{number}?"
    name = gets.chomp
    Player.new(name, game_piece)
  end
  
  def turn(player)
    column = move_input(player)
    grid.update(player.game_piece, column - 1)
    grid.show
  end

  private

  def game_set_up
    puts "\nLet's play a game of Connect Four in the command line"
    @first_player = create_player(1, 'X')
    @second_player = create_player(2, 'O')
  end

  def take_turns
    @current_player = first_player
    until grid.full?
      turn(current_player)
      break if grid.winner?(current_player.game_piece)

      @current_player = switch_current_player
    end
  end

  def move_input(player)
    puts "#{player.name}, please pick a column to drop your game piece (#{player.game_piece})"
    input = gets.chomp.to_i
    return input if grid.valid_column?(input)

    puts "That's not a valid column"
    move_input(player)
  end

  def switch_current_player
    current_player == first_player ? second_player : first_player
  end

  def conclusion
    if grid.winner?(current_player.game_piece)
      puts "#{current_player.name} wins!\n"
    else
      puts "It's a tie."
    end
  end
end