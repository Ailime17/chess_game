require './lib/rook'
require './lib/game'

describe RookMoves do
  let(:chess_game) { ChessGame.new }
  before do
    @player1 = chess_game.instance_variable_get(:@player1)
    @board = chess_game.instance_variable_get(:@board)
    subject.instance_variable_set(:@board, @board)
  end

  describe '#allowed_moves' do
    it 'returns the move (end square) if allowed for a rook' do
      expect(subject.allowed_moves(['e', 4], ['f', 4], @player1, @board)).to eql([['f', 4]])
    end
    it 'returns an empty array if move is not allowed for a rook' do
      expect(subject.allowed_moves(['e', 4], ['f', 5], @player1, @board)).to eql([])
    end
  end

  describe '#legal_and_empty_path?' do
    it 'returns true if move is legal for a rook and the path is empty' do
      expect(subject.legal_and_empty_path?(['e', 4], ['g', 4])).to be true
    end
    it 'returns false if move is not legal for a rook' do
      expect(subject.legal_and_empty_path?(['e', 4], ['f', 5])).to be false
    end
    it 'returns false if the path is not empty' do
      expect(subject.legal_and_empty_path?(['a', 1], ['a', 5])).to be false
    end
  end

  describe '#horizontal_path_empty?' do
    it 'returns true if all squares on the (horizontal) path are empty' do
      expect(subject.horizontal_path_empty?(['a', 3], ['e', 3])).to be true
    end
    it 'returns false if not all squares on the (horizontal) path are empty' do
      expect(subject.horizontal_path_empty?(['a', 1], ['c', 1])).to be false
    end
  end

  describe '#vertical_path_empty?' do
    it 'returns true if all squares on the (vertical) path are empty' do
      expect(subject.vertical_path_empty?(['a', 3], ['a', 5])).to be true
    end
    it 'returns false if not all squares on the (vertical) path are empty' do
      expect(subject.vertical_path_empty?(['a', 1], ['a', 5])).to be false
    end
  end

  describe '#square_empty?' do
    it 'returns true if the given square(key) on the hash board is empty (is assigned the value of an empty string)' do
      expect(subject.square_empty?(['a', 3])).to be true
    end
    it 'returns false if the given square(key) on the hash board is not empty (is assigned the value of a unicode piece)' do
      expect(subject.square_empty?(['c', 1])).to be false
    end
  end
end
