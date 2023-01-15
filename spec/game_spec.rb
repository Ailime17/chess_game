# frozen_string_literal: true

require './lib/game'

describe ChessGame do
  before do
    @player1 = subject.instance_variable_get(:@player1)
    @player2 = subject.instance_variable_get(:@player2)
  end

  describe '#start_new_game_or_continue_previous_session' do
    before do
      spec_helper_suppress_output
      allow(File).to receive(:exist?).and_return(true)
      allow(subject).to receive(:ask_to_open_saved_game)
    end
    context 'when player agrees to open saved game' do
      it 'opens saved game' do
        subject.instance_variable_set(:@player_opens_saved_game, true)
        allow(subject).to receive(:open_saved_game)
        expect(subject).to receive(:open_saved_game)
        subject.start_new_game_or_continue_previous_session
      end
    end
    context 'when player disagrees to open saved game (same when saved game does not exist)' do
      it 'sets up new game players' do
        subject.instance_variable_set(:@player_opens_saved_game, false)
        allow(subject).to receive(:set_up_players)
        expect(subject).to receive(:set_up_players)
        subject.start_new_game_or_continue_previous_session
      end
    end
  end

  describe '#checkmate?' do
    context "when one player's king is in checkmate" do
      it 'returns true' do
        allow(subject).to receive(:king_is_in_checkmate?).with(@player1).and_return(true)
        allow(subject).to receive(:king_is_in_checkmate?).with(@player2).and_return(false)
        expect(subject.checkmate?).to be true
        subject.checkmate?
      end
    end
  end

  describe '#draw?' do
    context 'when a condition for a draw is true' do
      it 'returns true' do
        allow(subject).to receive(:insufficient_material_draw?).and_return(true)
        allow(subject).to receive(:stalemate?).and_return(false)
        expect(subject.draw?).to be true
        subject.draw?
      end
    end
  end

  describe '#player_turn(player)' do
    before do
      spec_helper_suppress_output
      allow(subject).to receive(:player_exits_game?).and_return(false)
      allow(subject).to receive(:player_saves_game?).and_return(false)
      allow(subject).to receive(:make_move)
    end
    context "when bot player is activated & it's player number 2 turn" do
      it 'does random legal move' do
        subject.instance_variable_set(:@bot_activated, true)
        allow(subject).to receive(:random_legal_move)
        expect(subject).to receive(:random_legal_move)
        subject.player_turn(@player2)
      end
    end
    context "when bot player is not activated & it's player number 2 turn" do
      it 'asks player for next move' do
        subject.instance_variable_set(:@bot_activated, false)
        allow(subject).to receive(:get_next_move)
        expect(subject).to receive(:get_next_move)
        subject.player_turn(@player2)
      end
    end
    context "when bot player is activated but it's player number 1 turn" do
      it 'asks player for next move' do
        subject.instance_variable_set(:@bot_activated, true)
        allow(subject).to receive(:get_next_move)
        expect(subject).to receive(:get_next_move)
        subject.player_turn(@player1)
      end
    end
  end

  describe '#play_game' do
    context 'when one player wins' do
      it 'stops game loop and displays end message' do
        allow(subject).to receive(:start_new_game_or_continue_previous_session)
        allow(subject).to receive(:checkmate?).and_return(true)
        allow(subject).to receive(:display_end_message)
        expect(subject).to receive(:display_end_message)
        subject.play_game
      end
    end
  end
end
