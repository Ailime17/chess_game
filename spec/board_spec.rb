require './lib/board.rb'
require './lib/players.rb'

class ChessGameDummy
  include Board
end

describe Board do
  let(:instance) { ChessGameDummy.new }

  describe '#make_board' do
    matcher :have_64_key_value_pairs do
      match { |obj| obj.length == 64 }
    end
    it 'creates a chess board as a hash with squares as keys & pieces as values' do
      expect(instance.make_board).to be_kind_of(Hash)
    end
    it 'creates a chess board hash with 64 key-value pairs' do
      expect(instance.make_board).to have_64_key_value_pairs
    end
  end

  describe '#place_a_piece' do
    before do
      board = instance.make_board
      instance.instance_variable_set(:@board, board)
      @board = instance.instance_variable_get(:@board)
      instance.place_a_piece(@board, 'a', 2)
    end
    it 'fills the board (hash) with pieces (values) on the appropriate squares (keys)' do
      expect(@board[['a', 2]]).to_not eql('')
    end
    it 'leaves squares that should not be filled to remain empty' do
      expect(@board[['a', 3]]).to eql('')
    end
  end

  describe '#make_board_for_display' do
    it 'creates a visual (output) board' do
      expect(instance.make_board_for_display).to be_kind_of(String)
    end
  end

  describe '#place_pieces_on_board' do
    it 'places visual (output) pieces on the appropriate squares on the visual board' do
      board = instance.make_board_for_display
      instance.place_pieces_on_board(board)
      index_of_square_a_8 = board.index('8') + 4
      expect(board[index_of_square_a_8]).to_not eql('b')
    end
  end

  describe '#make_empty_black_squares_visibly_black' do
    it 'fills empty squares on the visual (output) board with visual black stars' do
      board = instance.make_board_for_display
      instance.make_empty_black_squares_visibly_black(board)
      index_of_one_of_black_squares = board.index('3') + 4
      expect(board[index_of_one_of_black_squares]).to_not eql(' ')
    end
  end

  describe '#read_squares' do
    matcher :have_length_32 do
      match { |obj| obj.length == 32 }
    end
    it 'creates an array of all the white (or black) squares on the board' do
      expect(instance.read_squares('white')).to have_length_32
    end
  end

  describe '#update_board' do
    before(:each) do
      board = instance.make_board
      instance.instance_variable_set(:@board, board)
      @board = instance.instance_variable_get(:@board)
      instance.update_board(['a', 2],['a', 3],'some unicode piece')
    end
    it 'assigns specified unicode piece as the new value(piece) for the specified key(square) of the hash board' do
      expect(@board[['a', 3]]).to eql('some unicode piece')
    end
    it 'also empties the square where the piece previously was (assigns an empty value)' do
      expect(@board[['a', 2]]).to eql('')
    end
  end

  describe '#update_board_for_display' do
    before(:each) do
      board = instance.make_board_for_display
      instance.instance_variable_set(:@board_for_display, board)
      @board_for_display = instance.instance_variable_get(:@board_for_display)
      instance.update_board_for_display(['a', 2], ['a', 4], 'some unicode piece')
    end
    it 'places the visual (unicode) piece on the specified square on the visual board' do
      index_of_square_a_4 = @board_for_display.index('4') + 4
      expect(@board_for_display[index_of_square_a_4]).to_not eql(' ')
    end
    it 'also empties the square where the piece previously was on the visual board' do
      index_of_square_a_2 = @board_for_display.index('2') + 4
      expect(@board_for_display[index_of_square_a_2]).to eql(' ')
    end
  end

  describe '#get_file_index' do
    context "when given a file name (e.g: 'a') as a parameter" do
      it 'returns the number for how many index places there are between the index place of (every) rank and (every) square of the given file on the visual board' do
        expect(instance.get_file_index('a')).to eql(4)
      end
    end
  end

  describe '#update_both_boards' do
    it 'calls both update_board & update_board_for_display with the same parameters that were passed to it' do
      allow(instance).to receive(:update_board).with(['a', 2], ['a', 4], 'some unicode piece')
      allow(instance).to receive(:update_board_for_display).with(['a', 2], ['a', 4], 'some unicode piece')
      expect(instance).to receive(:update_board).with(['a', 2], ['a', 4], 'some unicode piece')
      expect(instance).to receive(:update_board_for_display).with(['a', 2], ['a', 4], 'some unicode piece')
      instance.update_both_boards(['a', 2], ['a', 4], 'some unicode piece')
    end
  end
end