# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#play' do
    it 'shows the grid' do
      expect(game.grid).to receive(:show)
    end
  end
end