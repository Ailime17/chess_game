require './lib/pawn'
require './lib/game'

describe PawnMoves do
  let(:chess_game) { ChessGame.new }
  before do
    @player1 = chess_game.instance_variable_get(:@player1)
    @player2 = chess_game.instance_variable_get(:@player2)
    @board = chess_game.instance_variable_get(:@board)
    subject.instance_variable_set(:@board, @board)
  end

  describe '#allowed_moves' do
    context "if it's the pawn's first move & the given end_square is empty" do
      it 'returns 2 allowed forward moves (end squares) for the white pawn' do
        expect(subject.allowed_moves(['a', 2], ['a', 4], @player1, @board)).to eql([['a', 3], ['a', 4]])
      end
      it 'does the same for the black pawn' do
        expect(subject.allowed_moves(['a', 7], ['a', 5], @player2, @board)).to eql([['a', 6], ['a', 5]])
      end
    end
    context "if it's not the pawn's first move & the given end_square is empty" do
      it 'returns 1 allowed forward move (end square) for the white pawn' do
        expect(subject.allowed_moves(['a', 3], ['a', 4], @player1, @board)).to eql([['a', 4]])
      end
      it 'does the same for the black pawn' do
        expect(subject.allowed_moves(['a', 6], ['a', 5], @player2, @board)).to eql([['a', 5]])
      end
    end
    context 'if the given end_square is not empty' do
      it 'returns 2 allowed diagonal moves (end squares) for the white pawn' do
        expect(subject.allowed_moves(['b', 6], ['c', 7], @player1, @board)).to contain_exactly(['a', 7], ['c', 7])
      end
      it 'does the same for the black pawn' do
        expect(subject.allowed_moves(['b', 3], ['a', 2], @player2, @board)).to contain_exactly(['a', 2], ['c', 2])
      end
    end
  end

  describe '#one_square_forward' do
    context 'when given a plus symbol as an argument' do
      it 'returns square that is one rank bigger than the start square' do
        expect(subject.one_square_forward(['a', 2], :+)).to eql(['a', 3])
      end
    end
    context 'when given a minus symbol as an argument' do
      it 'returns square that is one rank smaller than the start square' do
        expect(subject.one_square_forward(['a', 7], :-)).to eql(['a', 6])
      end
    end
  end

  describe '#two_squares_forward' do
    context 'when given a plus symbol as an argument' do
      it 'returns square that is 2 ranks bigger than the start square' do
        expect(subject.two_squares_forward(['a', 2], :+)).to eql(['a', 4])
      end
    end
    context 'when given a minus symbol as an argument' do
      it 'returns square that is 2 ranks smaller than the start square' do
        expect(subject.two_squares_forward(['a', 7], :-)).to eql(['a', 5])
      end
    end
  end

  describe '#one_square_diagonally_forward_left_and_right' do
    context 'when given a plus symbol as an argument' do
      it 'returns an array of 2 closest diagonal squares that are one rank bigger than the start square' do
        expect(subject.one_square_diagonally_forward_left_and_right(['b', 2], :+)).to contain_exactly(['a', 3], ['c', 3])
      end
    end
    context 'when given a minus symbol as an argument' do
      it 'returns an array of 2 closest diagonal squares that are one rank smaller than the start square' do
        expect(subject.one_square_diagonally_forward_left_and_right(['b', 7], :-)).to contain_exactly(['a', 6], ['c', 6])
      end
    end
  end

  describe '#path_empty?' do
    context 'if the pawn is white & a square that is 1 rank bigger than the start square is empty' do
      it 'returns true' do
        expect(subject.path_empty?(['a', 2], @player1)).to be true
      end
    end
    context 'if the pawn is white & a square that is 1 rank bigger than the start square is not empty' do
      it 'returns false' do
        expect(subject.path_empty?(['a', 6], @player1)).to be false
      end
    end
    context 'if the pawn is black & a square that is 1 rank smaller than the start square is empty' do
      it 'returns true' do
        expect(subject.path_empty?(['a', 7], @player2)).to be true
      end
    end
    context 'if the pawn is black & a square that is 1 rank smaller than the start square is not empty' do
      it 'returns false' do
        expect(subject.path_empty?(['a', 3], @player2)).to be false
      end
    end
  end

  describe '#first_move?' do
    context "when the pawn is white & the start_square's rank is 2" do
      it 'returns true' do
        expect(subject.first_move?(['a', 2], @player1)).to be true
      end
    end
    context "when the pawn is white & the start_square's rank is not 2" do
      it 'returns false' do
        expect(subject.first_move?(['a', 3], @player1)).to be false
      end
    end
    context "when the pawn is black & the start_square's rank is 7" do
      it 'returns true' do
        expect(subject.first_move?(['a', 7], @player2)).to be true
      end
    end
    context "when the pawn is black & the start_square's rank is not 7" do
      it 'returns false' do
        expect(subject.first_move?(['a', 6], @player2)).to be false
      end
    end
  end
end
