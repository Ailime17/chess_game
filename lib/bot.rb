# module for the bot player
module Bot
  def random_legal_move
    board_squares = @board.keys.shuffle
    board_squares.each do |square|
      next unless piece_belongs_to_player?(square, @player2)

      @board.each_key do |end_square|
        next if piece_belongs_to_player?(end_square, @player2)

        return "#{square[0]}#{square[1]}#{end_square[0]}#{end_square[1]}" if legal_move?(square, end_square, @player2)
      end
    end
  end
end
