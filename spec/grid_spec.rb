# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/grid'
require_relative '../lib/player'

describe Grid do
  subject(:grid_test) { described_class.new}

  describe '#full?' do
    context 'when the grid is new' do
      it 'is not full' do
        expect(grid_test.full?).to be false
      end
    end

    context 'when the grid is partially full' do
      before do
        grid_test.instance_variable_set(:@board, [Array.new(3, 'X'), Array.new(3)])
      end

      it 'is not full' do
        expect(grid_test.full?).to be false
      end
    end

    context 'when the grid is full' do
      before do
        grid_test.instance_variable_set(:@board, Array.new(7) { Array.new(6, 'X') })
      end

      it 'is full' do
        expect(grid_test.full?).to be true
      end
    end
  end

  describe '#valid_column?' do
    context 'when the grid is new' do
      it 'is valid' do
        column = 1
        expect(grid_test.valid_column?(column)).to be true
      end
    end

    context 'when the column is full' do
      before do
        grid_test.instance_variable_set(:@available_columns, [1, 2, 4])
      end

      it 'is not valid' do
        column = 3
        expect(grid_test.valid_column?(column)).to be false
      end
    end

    context 'when the column input is not a number' do
      it 'is not valid' do
        column = '?'
        expect(grid_test.valid_column?(column)).to be false
      end
    end
  end

  describe '#nested_index' do
    context 'when the column is empty' do
      it 'returns 0' do
        chosen_column = 0
        found_index = grid_test.nested_index(chosen_column)
        expect(found_index).to eq(0)
      end
    end

    context 'when the column already has 2 game pieces' do
      before do
        grid_test.board[1][0] = 'X'
        grid_test.board[1][1] = 'O'
      end

      it 'returns 2' do
        chosen_column = 1
        found_index = grid_test.nested_index(chosen_column)
        expect(found_index).to eq(2)
      end
    end
  end

  describe '#update_board' do
    context 'when the grid is new' do
      before do
        grid_test.instance_variable_set(:@current_move, [0, 0])
      end

      it 'updates board with current move' do
        player_piece = 'X'
        grid_test.update_board(player_piece)
        board_move = grid_test.board[0][0]
        expect(board_move).to eq(player_piece)
      end
    end

    context 'when the chosen column already has 4 game pieces' do
      before do
        grid_test.board[5] = ['X', 'O', 'X', 'O', nil, nil]
        grid_test.instance_variable_set(:@current_move, [5, 4])
      end

      it 'updates board with current move' do
        player_piece = 'O'
        grid_test.update_board(player_piece)
        updated_board_column = grid_test.board[5]
        wanted_board_column = ['X', 'O', 'X', 'O', 'O', nil]
        expect(updated_board_column).to eq(wanted_board_column)
      end
    end
  end

  describe '#update_available_columns' do
    context 'when a column has 1 game piece' do
      before do
        grid_test.board[3][0] = 'O'
      end

      it 'does not change available_columns' do
        chosen_column = 3
        grid_test.update_available_columns(chosen_column)
        updated_available_columns = grid_test.available_columns
        wanted_available_columns = [1, 2, 3, 4, 5, 6, 7]
        expect(updated_available_columns).to eq(wanted_available_columns)
      end
    end

    context 'when a column is full' do
      before do
        grid_test.board[0] = ['X', 'X', 'X', 'O', 'X', 'O']
      end

      it 'removes that column from available columns' do
        chosen_column = 1
        grid_test.update_available_columns(chosen_column)
        updated_available_columns = grid_test.available_columns
        wanted_available_columns = [2, 3, 4, 5, 6, 7]
        expect(updated_available_columns).to eq(wanted_available_columns)
      end
    end
  end

  describe '#positive_slope' do
    context 'when coordinate is on edge of left half of the board' do
      before do
        grid_test.instance_variable_set(:@current_move, [0, 1])
      end

      it 'returns array with length of 1' do
        leg = grid_test.positive_slope
        expect(leg.length).to eq(1)
      end
    end

    context 'when coordinate is one of the middle spots on board' do
      before do
        grid_test.instance_variable_set(:@current_move, [3, 3])
      end

      it 'returns an array length of 3' do
        leg = grid_test.positive_slope
        expect(leg.length).to eq(3)
      end
    end
  end

  describe '#negative_slope' do
    context 'when coordinate is on edge of right half of the board' do
      before do
        grid_test.instance_variable_set(:@current_move, [4, 0])
      end

      it 'returns array with length of 1' do
        leg = grid_test.negative_slope
        expect(leg.length).to eq(1)
      end
    end

    context 'when coordinate is one of the middle spots on board' do
      before do
        grid_test.instance_variable_set(:@current_move, [3, 2])
      end

      it 'returns an array length of 3' do
        leg = grid_test.negative_slope
        expect(leg.length).to eq(3)
      end
    end    
  end

  describe 'zero_slope' do
    context 'when coordinate is on outter edge' do
      before do
        grid_test.instance_variable_set(:@current_move, [0, 2])
      end

      it 'returns an array length of 1'do
        leg = grid_test.zero_slope
        expect(leg.length).to eq(1)
      end
    end

    context 'when x-coordinate is one of the middle spots on board' do
      before do 
        grid_test.instance_variable_set(:@current_move, [3, 5])
      end

      it 'returns an array length of 4' do
        leg = grid_test.zero_slope
        expect(leg.length).to eq(4)
      end
    end   
  end

  describe '#undefined_slope' do
    context 'when y-coordinate is greater than 2' do
      before do
        grid_test.instance_variable_set(:@current_move, [4, 4])
      end

      it 'returns an array length of 1' do
        leg = grid_test.undefined_slope
        expect(leg.length).to eq(1)
      end
    end

    context 'when y-coordinate is less than 3' do
      before do
        grid_test.instance_variable_set(:@current_move, [2, 1])
      end

      it 'does not return anything' do
        leg = grid_test.undefined_slope
        expect(leg).to be_nil
      end
    end
  end

  describe '#possible_fours' do
    context 'when last move was at [0, 0]' do
      before do
        grid_test.instance_variable_set(:@current_move, [0, 0])
      end

      it 'returns an array length of 2' do
        legs = grid_test.possible_fours
        expect(legs.length).to eq(2)
      end
    end

    context 'when last move was at [3, 2]' do
      before do
        grid_test.instance_variable_set(:@current_move, [3, 2])
      end

      it 'returns an array length of 10' do
        legs = grid_test.possible_fours
        expect(legs.length).to eq(10)
      end
    end
  end

  describe '#winner?' do
    context 'there is only 1 piece on the board' do
      before do
        grid_test.board[2][0] = 'X'
        grid_test.instance_variable_set(:@current_move, [2, 0])
      end

      it 'does not have a winner' do
        player_piece = 'X'
        expect(grid_test.winner?(player_piece)).to be false
      end
    end

    context 'there is 4-in-a-row across the bottom' do
      before do
        grid_test.board[0][0] = 'O'
        grid_test.board[1][0] = 'O'
        grid_test.board[2][0] = 'O'
        grid_test.board[3][0] = 'O'
        grid_test.instance_variable_set(:@current_move, [1, 0])
      end

      it 'has a winner' do
        player_piece = 'O'
        expect(grid_test.winner?(player_piece)).to be true
      end
    end

    context 'there is a vertical 4-in-a-row' do
      before do
        grid_test.board[3] = ['X', 'X', 'O', 'O', 'O', 'O']
        grid_test.instance_variable_set(:@current_move, [3, 5])
      end

      it 'has a winner' do
        player_piece = 'O'
        expect(grid_test.winner?(player_piece)).to be true
      end
    end

    context 'there is a diagonal 4-in-a-row' do
      before do
        grid_test.board[3][2] = 'X'
        grid_test.board[4][3] = 'X'
        grid_test.board[5][4] = 'X'
        grid_test.board[6][5] = 'X'
        grid_test.instance_variable_set(:@current_move, [4, 3])
      end 

      it 'has a winner' do
        player_piece = 'X'
        expect(grid_test.winner?(player_piece)).to be true
      end
    end
  end
end