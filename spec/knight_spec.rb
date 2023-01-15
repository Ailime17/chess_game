require './lib/knight'
require './lib/game'

describe KnightMoves do
  RSpec::Matchers.define(:have_amount_of_end_squares) do |amount|
    match do |object|
      object.length == amount
    end
  end

  describe '#allowed_moves' do
    it 'returns an array of all allowed moves (end squares) for the knight from the given starting square' do
      chess_game = ChessGame.new
      @player1 = chess_game.instance_variable_get(:@player1)
      @board = chess_game.instance_variable_get(:@board)
      expect(subject.allowed_moves(['e', 4], ['e', 7], @player1, @board)).to have_amount_of_end_squares(8)
    end
  end

  describe '#vertical_and_right_or_left' do
    it 'returns an array of all allowed moves that start in vertical direction' do
      expect(subject.vertical_and_right_or_left(['e', 4])).to have_amount_of_end_squares(4)
    end
  end

  describe '#horizontal_and_up_or_down' do
    it 'returns an array of all allowed moves that start in horizontal direction' do
      expect(subject.horizontal_and_up_or_down(['e', 4])).to have_amount_of_end_squares(4)
    end
  end
end
