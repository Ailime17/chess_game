# class for the rook pieces
class RookMoves
  def initialize
    @visual_pieces = ["\u2656", "\u265C"]
  end

  # method used by ChessGame class to find out the piece's name by comparing unicodes
  def equals_unicode_piece?(unicode_piece)
    @visual_pieces.include?(unicode_piece)
  end

  def allowed_moves(start_square, end_square, _player, board)
    @board = board
    # preserving memory space version, because allowed_moves doesn't include all possible end_squares, only the one end_square if legal
    allowed_moves = []
    allowed_moves << end_square if legal_and_empty_path?(start_square, end_square)
    allowed_moves
  end

  def legal_and_empty_path?(start_square, end_square)
    start_file = start_square[0]
    end_file = end_square[0]
    start_rank = start_square[1]
    end_rank = end_square[1]
    if start_rank == end_rank
      return false unless horizontal_path_empty?(start_square, end_square)
    elsif start_file == end_file
      return false unless vertical_path_empty?(start_square, end_square)
    else
      return false
    end
    true
  end

  def horizontal_path_empty?(start_square, end_square)
    start_file = start_square[0]
    end_file = end_square[0]
    add_or_substract = if start_file < end_file
                         :+
                       elsif start_file > end_file
                         :-
                       end
    square = [start_square[0], start_square[1]]
    square[0] = (square[0].ord.public_send(add_or_substract, 1)).chr
    until square == end_square
      return false unless square_empty?(square)

      square[0] = (square[0].ord.public_send(add_or_substract, 1)).chr
    end
    true
  end

  def vertical_path_empty?(start_square, end_square)
    start_rank = start_square[1]
    end_rank = end_square[1]
    add_or_substract = if start_rank < end_rank
                         :+
                       elsif start_rank > end_rank
                         :-
                       end
    square = [start_square[0], start_square[1]]
    square[1] = square[1].public_send(add_or_substract, 1)
    until square == end_square
      return false unless square_empty?(square)

      square[1] = square[1].public_send(add_or_substract, 1)
    end
    true
  end

  def square_empty?(square)
    @board[square].empty?
  end
end
