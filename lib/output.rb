# module for output messages displayed during chess game
module Messages
  def display_chess_board
    puts @board_for_display
  end

  def introduce_game
    puts %{
      Welcome to the game of chess! To make a move, write the current
    position of your piece followed by the position you want your piece
    to go to, e.g. a2a4, e2e3, b2b4 etc. .
    }
  end

  def complete_introduction
    puts %{
      To save the game at any point: enter 's',
      to exit the game: enter 'x'.
      3.. 2.. 1.. Game starts.
    }
  end

  def ask_about_opponent
    print %{
      Do you want to play against a bot?
      y / n
      > }
  end

  def wrong_opponent_answer_so_ask_again
    print %{
    Oops! I don't understand. Do you want to play against a bot?
    Y / N
    > }
  end

  def inform_of_great_choice
    puts %{ 
    Great choice!
    }
  end

  def display_end_message
    if checkmate?
      puts 'Checkmate! Game over'
    elsif draw?
      puts "It's a draw! Game over"
    elsif @game_exited
      puts 'Game exited'
    end
  end

  def ask_for_next_move(player)
    color = (player.color == 'white' ? 'White' : 'Black')
    puts "#{color} player, Make your move"
    print '> '
  end

  def wrong_move_input_so_ask_again
    puts 'Incorrect or illegal choice. Try again'
    print '> '
  end

  def inform_of_saved_game
    puts 'Game saved.'
  end

  def inform_of_move_bot_made_if_bot_is_activated(next_move, player)
    puts "Computer move: #{next_move}" if @bot_activated == true && player == @player2
  end

  def inform_and_ask_about_pawn_promotion
    puts %{
    Good job! Choose a piece you want your pawn to be promoted to:
    Queen / Knight / Rook / Bishop
    }
    print '> '
  end

  def wrong_promotion_answer_so_ask_again
    puts %{
    Try again. Choose a piece you want your pawn to be promoted to:
    Queen / Knight / Rook / Bishop
    }
    print '> '
  end
end
