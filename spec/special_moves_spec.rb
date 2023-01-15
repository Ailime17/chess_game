require './lib/special_moves'
require './lib/game'

describe SpecialMoves do
  let(:instance) { ChessGame.new }
  let(:player1) { instance.instance_variable_get(:@player1) }

  describe '#king_moves_2_places_horizontally?' do
    it 'returns appropriate boolean (true) value' do
      expect(instance.king_moves_2_places_horizontally?(['e', 1], ['g', 1])).to be true
    end
    it 'returns appropriate boolean (false) value' do
      expect(instance.king_moves_2_places_horizontally?(['e', 1], ['h', 1])).to be false
    end
  end

  describe '#king_moved_towards_rook_h?' do
    it 'returns appropriate boolean (true) value' do
      expect(instance.king_moved_towards_rook_h?(['e', 1], ['g', 1])).to be true
    end
    it 'returns appropriate boolean (false) value' do
      expect(instance.king_moved_towards_rook_h?(['e', 1], ['c', 1])).to be false
    end
  end

  describe '#path_between_king_and_rook_empty?' do
    it 'returns appropriate boolean (true) value' do
      allow(instance).to receive(:king_moved_towards_rook_h?).with(['e', 1], ['g', 1]).and_return(true)
      allow(player1).to receive(:rook_square).with('h').and_return(['h', 1])
      allow(instance).to receive(:square_empty?).with(['f', 1]).and_return(true)
      allow(instance).to receive(:square_empty?).with(['g', 1]).and_return(true)
      expect(instance.path_between_king_and_rook_empty?(['e', 1], ['g', 1], player1)).to be true
      instance.path_between_king_and_rook_empty?(['e', 1], ['g', 1], player1)
    end
    it 'returns appropriate boolean (false) value' do
      allow(instance).to receive(:king_moved_towards_rook_h?).with(['e', 1], ['g', 1]).and_return(true)
      allow(player1).to receive(:rook_square).with('h').and_return(['h', 1])
      allow(instance).to receive(:square_empty?).with(['f', 1]).and_return(false)
      expect(instance.path_between_king_and_rook_empty?(['e', 1], ['g', 1], player1)).to be false
      instance.path_between_king_and_rook_empty?(['e', 1], ['g', 1], player1)
    end 
  end

  describe '#king_will_be_in_check_during_castling?' do
    it 'returns appropriate boolean (true) value' do
      allow(instance).to receive(:king_moved_towards_rook_h?).with(['e', 1], ['g', 1]).and_return(true)
      allow(instance).to receive(:move_puts_the_king_in_check?).with(['e', 1], ['f', 1], player1).and_return(true)
      expect(instance.king_will_be_in_check_during_castling?(['e', 1], ['g', 1], player1)).to be true
      instance.king_will_be_in_check_during_castling?(['e', 1], ['g', 1], player1)
    end
    it 'returns appropriate boolean (false) value' do
      allow(instance).to receive(:king_moved_towards_rook_h?).with(['e', 1], ['g', 1]).and_return(true)
      allow(instance).to receive(:move_puts_the_king_in_check?).with(['e', 1], ['f', 1], player1).and_return(false)
      allow(instance).to receive(:move_puts_the_king_in_check?).with(['e', 1], ['g', 1], player1).and_return(false)
      expect(instance.king_will_be_in_check_during_castling?(['e', 1], ['g', 1], player1)).to be false
      instance.king_will_be_in_check_during_castling?(['e', 1], ['g', 1], player1)
    end
  end

  describe '#en_passant?' do
    context 'when opponent did not make any move yet (game only just started)' do
      it 'returns false' do
        instance_variable_set(:@most_recent_move, nil)
        expect(instance.en_passant?(['a', 2], ['a', 4], player1)).to be false
      end
    end
  end

  describe '#opponent_pawn_just_moved_two_places?' do
    before do
      @pawn = instance.instance_variable_get(:@pawn)
      instance.instance_variable_set(:@most_recent_start_square, ['a',7])
    end
    after(:each) do
      instance.opponent_pawn_just_moved_two_places?
    end
    it 'returns true when pawn moved two places' do
      instance.instance_variable_set(:@most_recent_end_square, ['a',5])
      allow(instance).to receive(:read_piece_name).with(['a',5]).and_return(@pawn)
      expect(instance.opponent_pawn_just_moved_two_places?).to be true
    end
    it 'returns false when pawn moved one place' do
      instance.instance_variable_set(:@most_recent_end_square, ['a',6])
      allow(instance).to receive(:read_piece_name).with(['a',6]).and_return(@pawn)
      expect(instance.opponent_pawn_just_moved_two_places?).to be false
    end
    it 'returns false when moved piece was not a pawn' do
      instance.instance_variable_set(:@most_recent_end_square, ['a',5])
      allow(instance).to receive(:read_piece_name).with(['a',5]).and_return('not a pawn')
      expect(instance.opponent_pawn_just_moved_two_places?).to be false
    end
  end

  describe '#opponent_pawn_just_sat_next_to_player_pawn?' do
    before do
      instance.instance_variable_set(:@most_recent_end_square, ['a', 5])
    end
    context "when opponent's pawn landed at a square horizontally next to player's square" do
      it 'returns true' do
        expect(instance.opponent_pawn_just_sat_next_to_player_pawn?(['b', 5])).to be true
      end
    end
    context "when opponent's pawn landed at a square that is not next to player's square" do
      it 'returns false' do
        expect(instance.opponent_pawn_just_sat_next_to_player_pawn?(['c', 5])).to be false
      end
    end
  end

  describe '#player_pawn_moves_where_the_opponent_pawn_would_be_if_it_moved_one_place?' do
    before do
      instance.instance_variable_set(:@most_recent_start_square, ['a', 7])
      instance.instance_variable_set(:@most_recent_end_square, ['a', 5])
    end
    it 'returns appropriate boolean (true) value' do
      expect(instance.player_pawn_moves_where_the_opponent_pawn_would_be_if_it_moved_one_place?(player1, ['a', 6])).to be true
    end
    it 'returns appropriate boolean (false) value' do
      expect(instance.player_pawn_moves_where_the_opponent_pawn_would_be_if_it_moved_one_place?(player1, ['a', 7])).to be false
    end
  end

  describe '#promotion?' do
    before do
      @pawn = instance.instance_variable_get(:@pawn)
      @board = instance.instance_variable_get(:@board)
    end
    context 'when the pawn reached the opposite end of the board' do
      it 'returns true' do
        allow(@pawn).to receive(:equals_unicode_piece?).and_return(true)
        allow(instance).to receive(:pawn_reached_the_end_of_the_board?).and_return(true)
        expect(instance.promotion?(['a', 8], player1)).to be true
      end
    end
    context 'when the pawn did not reach the opposite end of the board' do
      it 'returns false' do
        allow(@pawn).to receive(:equals_unicode_piece?).and_return(true)
        allow(instance).to receive(:pawn_reached_the_end_of_the_board?).and_return(false)
        expect(instance.promotion?(['a', 7], player1)).to be false
      end
    end
    context 'when the piece is not a pawn' do
      it 'returns false' do
        allow(@pawn).to receive(:equals_unicode_piece?).and_return(false)
        expect(instance.promotion?(['a', 8], player1)).to be false
      end
    end
  end

  describe '#pawn_reached_the_end_of_the_board?' do
    context 'when the rank is 8 and the pawn is white' do
      it 'returns true' do
        expect(instance.pawn_reached_the_end_of_the_board?(['a', 8], player1)).to be true
      end
    end
    context 'when the rank is not 8 and the pawn is white' do
      it 'returns false' do
        expect(instance.pawn_reached_the_end_of_the_board?(['a', 7], player1)).to be false
      end
    end
  end
end
