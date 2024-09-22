# frozen_string_literal: true

class Grid
  attr_reader :board, :available_columns

  def initialize
    @board = Array.new(7) { Array.new(6) }
    @available_columns = [1, 2, 3, 4, 5, 6, 7]
  end

  def show
    puts <<-HEREDOC

      |---+---+---+---+---+---+---|
      | #{board[0][5]} | #{board[1][5]} | #{board[2][5]} | #{board[3][5]} | #{board[4][5]} | #{board[5][5]} | #{board[6][5]} |
      |---+---+---+---+---+---+---|
      | #{board[0][4]} | #{board[1][4]} | #{board[2][4]} | #{board[3][4]} | #{board[4][4]} | #{board[5][4]} | #{board[6][4]} |
      |---+---+---+---+---+---+---|
      | #{board[0][3]} | #{board[1][3]} | #{board[2][3]} | #{board[3][3]} | #{board[4][3]} | #{board[5][3]} | #{board[6][3]} |
      |---+---+---+---+---+---+---|
      | #{board[0][2]} | #{board[1][2]} | #{board[2][2]} | #{board[3][2]} | #{board[4][2]} | #{board[5][2]} | #{board[6][2]} |
      |---+---+---+---+---+---+---|
      | #{board[0][1]} | #{board[1][1]} | #{board[2][1]} | #{board[3][1]} | #{board[4][1]} | #{board[5][1]} | #{board[6][1]} |
      |---+---+---+---+---+---+---|
      | #{board[0][0]} | #{board[1][0]} | #{board[2][0]} | #{board[3][0]} | #{board[4][0]} | #{board[5][0]} | #{board[6][0]} |
      |---+---+---+---+---+---+---|

    HEREDOC
  end

  def full?
    board.flatten.none?(nil)
  end

  def valid_column?(column)
    available_columns.include?(column)
  end

  def update_board(game_piece, column)
    idx = nested_index(column)
    board[column][idx] = game_piece

  end

  def nested_index(column)
    board[column].index(nil)
  end

  def update_available_columns(column)
    available_columns.delete(column) if board[column - 1].none?(nil)
  end

  def winner?
    
  end

end

# grid = Grid.new
# grid.board[0][0] = 'X'
# grid.board[0][1] = 'X'
# grid.show