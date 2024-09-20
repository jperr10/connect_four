# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/grid'
require_relative '../lib/player'

describe Game do
  subject(:game) { described_class.new }

  # before do
  #   game.instance_variable_set(:@grid, instance_double(Grid))
  # end

  describe '#play' do
    it 'shows the grid' do
      allow(game).to receive(:game_set_up)
      allow(game).to receive(:take_turns)
      expect(game.grid).to receive(:show)
      game.play
    end
  end

  describe '#create_player' do
    it 'creates player 1' do
      player_name = 'bob'
      player_piece = 'X'
      allow(game).to receive(:puts).twice
      allow(game).to receive(:gets).and_return(player_name)
      expect(Player).to receive(:new).with(player_name, player_piece)
      game.create_player(1, 'X')
    end
  end

  describe '#turn' do
    let(:player) { double('player', name: 'bob', game_piece: 'X')}

    context 'when grid is empty' do
      it 'updates the grid' do
        player_column_input = 1
        allow(game).to receive(:move_input).and_return(player_column_input)
        expect(game.grid).to receive(:update_grid).with(player.game_piece, player_column_input)
        game.turn(player)
      end
    end
  end
end


