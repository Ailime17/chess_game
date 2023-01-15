require './lib/bishop'
require './lib/game'

describe BishopMoves do
  let(:chess_game) { ChessGame.new }
  before do
    @player1 = chess_game.instance_variable_get(:@player1)
    @board = chess_game.instance_variable_get(:@board)
    subject.instance_variable_set(:@board, @board)
  end

  describe '#allowed_moves' do
    it 'returns the given move (end_square) if allowed for the bishop' do
      expect(subject.allowed_moves(['a', 3], ['b', 4], @player1, @board)).to eql([['b', 4]])
    end
    it 'returns an empty array if move (end_square) is not allowed for the bishop' do
      expect(subject.allowed_moves(['a', 3], ['b', 3], @player1, @board)).to eql([])
    end
  end

  describe '#legal_and_empty_path?' do
    it 'returns true if the move (end_square) is legal for the bishop and the path is empty' do
      expect(subject.legal_and_empty_path?(['a', 3], ['c', 5])).to be true
    end
    it 'returns false if the given move (end_square) is not legal for the bishop' do
      expect(subject.legal_and_empty_path?(['a', 3], ['a', 6])).to be false
    end
    it 'returns false if the path is not empty' do
      expect(subject.legal_and_empty_path?(['c', 1], ['f', 4])).to be false
    end
  end

  describe '#count_places' do
    it 'counts the amount of positions the file grew' do
      expect(subject.count_places(['a', 3], ['d', 6], 'file')).to eql(3)
    end
    it 'counts the amount of positions the file declined' do
      expect(subject.count_places(['d', 6], ['a', 3], 'file')).to eql(3)
    end
    it 'counts the amount of positions the rank grew' do
      expect(subject.count_places(['a', 3], ['d', 6], 'rank')).to eql(3)
    end
    it 'counts the amount of positions the rank declined' do
      expect(subject.count_places(['d', 6], ['a', 3], 'rank')).to eql(3)
    end
  end

  describe '#diagonal_path_empty?' do
    it 'returns true if path between start square & end square is empty' do
      expect(subject.diagonal_path_empty?('up', ['a', 3], ['d', 6])).to be true
    end
    it 'returns false if not all squares between start square & end square are empty' do
      expect(subject.diagonal_path_empty?('up', ['d', 4], ['a', 1])).to be false
    end
  end
end
