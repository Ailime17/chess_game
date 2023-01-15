require './lib/king'
require './lib/game'

describe KingMoves do

  RSpec::Matchers.define(:include_amount_of_end_squares) do |expected_amount|
    match do |object|
      object.length == expected_amount
    end
  end

  describe '#allowed_moves' do
    before do
      chess_game = ChessGame.new
      @player1 = chess_game.instance_variable_get(:@player1)
      @board = chess_game.instance_variable_get(:@board)
    end
    it 'returns an array of all possible moves (end_squares)' do
      expect(subject.allowed_moves(['e', 4], ['f', 4], @player1, @board)).to include_amount_of_end_squares(8)
    end
  end

  describe '#diagonal_moves' do
    it 'returns an array of all possible diagonal moves (end_squares)' do
      expect(subject.diagonal_moves('e', 4)).to include_amount_of_end_squares(4)
    end
  end

  describe '#horizontal_moves' do
    it 'returns an array of all possible horizontal moves (end_squares)' do
      expect(subject.horizontal_moves('e', 4)).to include_amount_of_end_squares(2)
    end
  end

  describe '#vertical_moves' do
    it 'returns an array of all possible vertical moves (end_squares)' do
      expect(subject.vertical_moves('e', 4)).to include_amount_of_end_squares(2)
    end
  end
end
