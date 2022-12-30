require_relative 'players'

# class for the pawn pieces
class PawnMoves
  def initialize
    @visual_pieces = ["\u2659", "\u265F"]
  end

  # method used by ChessGame class to find out the piece's name by comparing unicodes
  def equals_unicode_piece?(unicode_piece)
    @visual_pieces.include?(unicode_piece)
  end

  def allowed_moves(start_square, end_square, player, board)
    @board = board
    allowed_moves = []
    add_or_substract = case player.color
                       when 'white' then :+
                       when 'black' then :-
                       end
    if square_empty?(end_square)
      allowed_moves << one_square_forward(start_square, add_or_substract)
      allowed_moves << two_squares_forward(start_square, add_or_substract) if first_move?(start_square, player) && path_empty?(start_square, player)
    else
      allowed_moves.concat(one_square_diagonally_forward(start_square, add_or_substract))
    end
    allowed_moves.select! { |move| @board.key?(move) }
    allowed_moves
  end

  def one_square_forward(start_square, add_or_substract)
    [start_square[0], start_square[1].public_send(add_or_substract, 1)]
  end

  def two_squares_forward(start_square, add_or_substract)
    [start_square[0], start_square[1].public_send(add_or_substract, 2)]
  end

  def one_square_diagonally_forward(start_square, add_or_substract)
    [[(start_square[0].ord - 1).chr, start_square[1].public_send(add_or_substract, 1)], [(start_square[0].ord + 1).chr, start_square[1].public_send(add_or_substract, 1)]]
  end

  def path_empty?(start_square, player)
    # path_is_empty = true
    # square = start_square
    # until square == end_square
    #   square[1] += 1
    #   return false unless square_empty?(square)
    # end
    # path_is_empty
    if player.color == 'white'
      square = [start_square[0], start_square[1] + 1]
      square_empty?(square)
    elsif player.color == 'black'
      square = [start_square[0], start_square[1] - 1]
      square_empty?(square)
    end
  end

  # def makes_a_capture?(start_square, player)
  #   if player == @player1
  #   elsif player == @player2
  #   end
  # end

  def square_empty?(square)
    @board[square].empty?
  end

  def first_move?(start_square, player)
    if player.color == 'white'
      start_square[1] == 2
    elsif player.color == 'black'
      start_square[1] == 7
    end
  end
end
