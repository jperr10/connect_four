# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/grid'
require_relative '../lib/player'

describe Grid do
  subject(:grid_test) { described_class.new}

  describe '#valid_column?' do
    context 'when the grid is empty' do
      it 'returns true' do
        column = 1
        expect(grid_test.valid_column?(column)).to be true
      end
    end

    context 'when the column is full' do
      before do
        grid_test.instance_variable_set(:@available_columns, [1, 2, 4])
      end

      it 'returns false' do
        column = 3
        expect(grid_test.valid_column?(column)).to be false
      end
    end

    context 'when the column input is not a number' do
      it 'returns false' do
        column = '?'
        expect(grid_test.valid_column?(column)).to be false
      end
    end
  end
end