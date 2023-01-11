require 'yaml'

# module for methods for saving and opening saved game
module YamlChessGame
  def ask_to_save_game
    answer_to_save_game = get_answer_to_save_game
    save_game if answer_to_save_game == 'y'
  end

  def get_answer_to_save_game
    puts 'Save game before exiting? y / n'
    print '> '
    answer = gets.strip.downcase
    until %w[y n].include?(answer)
      puts "Oops! I don't understand. Save game before exiting? \ny / n"
      print '> '
      answer = gets.strip.downcase
    end
    answer
  end

  def save_game
    yaml = YAML.dump(
      'player1' => @player1,
      'player2' => @player2,
      'board' => @board,
      'board_for_display' => @board_for_display,
      'bot_activated' => @bot_activated,
      'player_number' => @player_number
    )
    game_file = File.open('saved_yaml/saved_game.yaml', 'w')
    game_file.write(yaml)
    game_file.close
  end

  def ask_to_open_saved_game
    answer_to_open_game = get_answer_to_open_game
    @player_opens_saved_game = true if answer_to_open_game == 'y'
  end

  def get_answer_to_open_game
    print %{
      --- There is a saved game from the previous session. Open it?
      y / n
      > }
    answer = gets.strip.downcase
    until %w[y n].include?(answer)
      print %{
        Oops! I don't understand. Open saved game from the previous session?
        y / n
        > }
      answer = gets.strip.downcase
    end
    answer
  end

  def open_saved_game
    game_file = File.open('saved_yaml/saved_game.yaml', 'r')
    yaml = game_file.read
    file = Psych.unsafe_load(yaml)
    @player1 = file['player1']
    @player2 = file['player2']
    @board = file['board']
    @board_for_display = file['board_for_display']
    @bot_activated = file['bot_activated']
    @player_number = file['player_number']
  end
end
