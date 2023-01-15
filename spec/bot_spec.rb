require './lib/bot'
require './lib/game'

describe Bot do
  let(:chess_game) { ChessGame.new }

  describe '#random_legal_move' do
    it 'returns a random (legal) next move as a string that would otherwise be required to be inputted by a human player if bot was not activated' do
      expect(chess_game.random_legal_move).to be_kind_of(String)
    end
    matcher :be_four_chars_long do
      match { |obj| obj.length == 4 }
    end
    it 'and that is 4 characters long' do
      expect(chess_game.random_legal_move).to be_four_chars_long
    end
  end
end
