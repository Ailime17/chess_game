require './lib/yaml_chess'

class ChessGameDummy
  include YamlChessGame
end

describe YamlChessGame do
  let(:instance) { ChessGameDummy.new }

  describe '#ask_to_save_game' do
    context 'when player agrees to save game' do
      it 'saves game' do
        allow(instance).to receive(:get_answer_to_save_game).and_return('y')
        allow(instance).to receive(:save_game)
        expect(instance).to receive(:save_game)
        instance.ask_to_save_game
      end
    end
    context 'when playes disagrees to save game' do
      it 'does nothing' do
        allow(instance).to receive(:get_answer_to_save_game).and_return('n')
        allow(instance).to receive(:save_game)
        expect(instance).not_to receive(:save_game)
        instance.ask_to_save_game
      end
    end
  end
  describe '#get_answer_to_save_game' do
    before do
      spec_helper_suppress_output
    end

    context 'when player enters valid input' do
      it 'returns the input' do
        allow(instance).to receive(:gets).and_return('y')
        expect(instance.get_answer_to_save_game).to eql('y')
        instance.get_answer_to_save_game
      end
    end
  end

  describe '#ask_to_open_saved_game' do
    context 'when player agrees to open saved game' do
      it 'sets @player_opens_saved_game to true' do
        allow(instance).to receive(:get_answer_to_open_game).and_return('y')
        expect(instance.ask_to_open_saved_game).to be true
        instance.ask_to_open_saved_game
      end
    end
  end

  describe '#get_answer_to_open_game' do
    before do
      spec_helper_suppress_output
    end

    context 'when player enters valid input' do
      it 'returns the input' do
        allow(instance).to receive(:gets).and_return('y')
        expect(instance.get_answer_to_open_game).to eql('y')
        instance.get_answer_to_open_game
      end
    end
  end
end