require './lib/output'
require './lib/game'

describe Messages do
  let(:chess_game) { ChessGame.new }

  before do
    @player1 = chess_game.instance_variable_get(:@player1)
    @player2 = chess_game.instance_variable_get(:@player2)
  end

  describe '#display_end_message' do
    it 'displays a specific message depending which condition is true' do
      allow(chess_game).to receive(:checkmate?).and_return(false)
      allow(chess_game).to receive(:draw?).and_return(true)
      expect(chess_game).to receive(:display_end_message).and_return("It's a draw! Game over")
      chess_game.display_end_message
    end
  end

  describe '#ask_for_next_move' do
    it "displays a message addressing a specific player depending on which player's turn it is" do
      expect(chess_game).to receive(:ask_for_next_move).with(@player1).and_return('White player, Make your move')
      chess_game.ask_for_next_move(@player1)
    end
  end

  describe '#inform_of_move_bot_made_if_bot_is_activated' do
    context "when bot is activated & it is @player2's turn" do
      it 'informs of a move bot made' do
        chess_game.instance_variable_set(:@bot_activated, true)
        allow(chess_game).to receive(:inform_of_move_bot_made_if_bot_is_activated).with('a7a5', @player2)
        expect(chess_game).to receive(:inform_of_move_bot_made_if_bot_is_activated).with('a7a5', @player2).and_return('Computer move: a7a5')
        chess_game.inform_of_move_bot_made_if_bot_is_activated('a7a5', @player2)
      end
    end
    context "when bot is activated & it is @player1's turn" do
      it 'does not display anything' do
        chess_game.instance_variable_set(:@bot_activated, true)
        allow(chess_game).to receive(:inform_of_move_bot_made_if_bot_is_activated).with('a7a5', @player1)
        expect(chess_game).to receive(:inform_of_move_bot_made_if_bot_is_activated).with('a7a5', @player1).and_return(nil)
        chess_game.inform_of_move_bot_made_if_bot_is_activated('a7a5', @player1)
      end
    end
    context "when bot is not activated & it is @player2's turn" do
      it 'does not display anything' do
        chess_game.instance_variable_set(:@bot_activated, false)
        allow(chess_game).to receive(:inform_of_move_bot_made_if_bot_is_activated).with('a7a5', @player2)
        expect(chess_game).to receive(:inform_of_move_bot_made_if_bot_is_activated).with('a7a5', @player2).and_return(nil)
        chess_game.inform_of_move_bot_made_if_bot_is_activated('a7a5', @player2)
      end
    end
  end
end
