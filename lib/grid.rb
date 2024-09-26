# frozen_string_literal: true

class Grid
  attr_reader :board, :available_columns, :current_move

  FOUR_IN_A_ROW_COMBOS = [
    [[1, 1], [2, 2], [3, 3]], [[1, 0], [2, 0], [3, 0]],
    [[1, -1], [2, -2], [3, -3]], [[0, -1], [0, -2], [0, -3]],
    [[-1, -1], [-2, -2], [-3, -3]], [[-1, 0], [-2, 0], [-3, 0]],
    [[-1, 1], [-2, 2], [-3, 3]]
  ].freeze

  def initialize
    @board = Array.new(7) { Array.new(6, ' ') }
    @available_columns = [1, 2, 3, 4, 5, 6, 7]
    @current_move = nil
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
        1   2   3   4   5   6   7

    HEREDOC
  end

  def full?
    board.flatten.none?(' ')
  end

  def valid_column?(column)
    available_columns.include?(column)
  end

  def update(game_piece, column)
    update_current_move(column)
    update_board(game_piece)
    update_available_columns(column)
  end

  def update_current_move(column)
    @current_move = [column, nested_index(column)]
  end

  def update_board(game_piece)
    board[current_move[0]][current_move[1]] = game_piece
  end

  def nested_index(column)
    board[column].index(' ')
  end

  def update_available_columns(column)
    available_columns.delete(column) if board[column - 1].none?(' ')
  end

  def winner?(game_piece)
    legs = possible_fours

    legs.any? do |leg|
      [board[leg[0][0]][leg[0][1]],
      board[leg[1][0]][leg[1][1]],
      board[leg[2][0]][leg[2][1]],
      board[leg[3][0]][leg[3][1]]
      ].all?(game_piece)
    end
  end

  def possible_fours
    result = []
    legs = []

    legs << positive_slope
    legs << negative_slope
    legs << zero_slope
    legs << undefined_slope

    legs.compact.select { |leg| leg.length > 0 }.each do |leg|
      leg.each do |e|
        result << e
      end
    end
    result
  end

  def positive_slope
    x_cord = current_move[0]
    y_cord = current_move[1]
    arr = []
    i = 3
    while i >= 0  do
      arr << [
        [x_cord + i, y_cord + i],
        [x_cord + (i - 1), y_cord + (i - 1)],
        [x_cord + (i - 2), y_cord + (i - 2)],
        [x_cord + (i - 3), y_cord + (i - 3)]
      ]
      i -= 1
    end
    arr.select do |leg|
      leg.all? { |cord| cord[0].between?(0, 6) && cord[1].between?(0, 5) }
    end
  end

  def negative_slope
    x_cord = current_move[0]
    y_cord = current_move[1]
    arr = []
    i = 3
    while i >= 0  do
      arr << [
        [x_cord - i, y_cord + i],
        [x_cord - (i - 1), y_cord + (i - 1)],
        [x_cord - (i - 2), y_cord + (i - 2)],
        [x_cord - (i - 3), y_cord + (i - 3)]
      ]
      i -= 1
    end
    arr.select do |leg|
      leg.all? { |cord| cord[0].between?(0, 6) && cord[1].between?(0, 5) }
    end
  end

  def zero_slope
    x_cord = current_move[0]
    y_cord = current_move[1]
    arr = []
    i = 3
    while i >= 0  do
      arr << [
        [x_cord + i, y_cord],
        [x_cord + (i - 1), y_cord],
        [x_cord + (i - 2), y_cord],
        [x_cord + (i - 3), y_cord]
      ]
      i -= 1
    end
    arr.select do |leg|
      leg.all? { |cord| cord[0].between?(0, 6) && cord[1].between?(0, 5) }
    end
  end

  def undefined_slope
    x_cord = current_move[0]
    y_cord = current_move[1]
    [
      [[x_cord, y_cord - 3], [x_cord, y_cord - 2],
      [x_cord, y_cord - 1], [x_cord, y_cord]]
    ] if y_cord - 3 >= 0
  end

end

# grid = Grid.new
# grid.board[0][0] = 'X'
# grid.board[0][1] = 'X'
# grid.show