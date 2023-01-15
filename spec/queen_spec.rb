require './lib/queen'
require './lib/game'

describe QueenMoves do
  describe '#equals_unicode_piece?' do
    context 'when given a unicode piece that also exists in the @visual_pieces array' do
      it 'returns true' do
        expect(subject.equals_unicode_piece?("\u2655")).to be true
      end
    end
    context 'when given a unicode piece that does not exist in the @visual_pieces array' do
      it 'returns false' do
        expect(subject.equals_unicode_piece?("\u2600")).to be false
      end
    end
  end

  let(:chess_game) { ChessGame.new }
  describe '#allowed_moves' do
    before do
      @player1 = chess_game.instance_variable_get(:@player1)
      @board = chess_game.instance_variable_get(:@board)
    end
    it 'includes a move (end_square) if it is legal for a rook or a bishop' do
      expect(subject.allowed_moves(['a', 4], ['b', 4], @player1, @board)).to eql([['b', 4]])
    end
    it 'does not include a move (end_square) if it is not legal for a rook or a bishop (e.g. if it requires jumping over pieces)' do
      expect(subject.allowed_moves(['a', 1], ['a', 3], @player1, @board)).to eql([])
    end
  end
end
