# class for the bishop pieces
class BishopMoves
  def initialize
    @visual_pieces = ["\u2657", "\u265D"]
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
    amount_of_places_that_the_rank_grew_or_declined = count_places(start_square, end_square, 'rank')
    amount_of_places_that_the_file_grew_or_declined = count_places(start_square, end_square, 'file')
    return false if start_file == end_file || start_rank == end_rank || 
    # to check if it's a diagonal line (= grows proportionally)
    (amount_of_places_that_the_rank_grew_or_declined != amount_of_places_that_the_file_grew_or_declined)

    if start_rank < end_rank
      return false unless diagonal_path_empty?('up', start_square, end_square)
    elsif start_rank > end_rank
      return false unless diagonal_path_empty?('down', start_square, end_square)
    end
    true
  end

  def count_places(start_square, end_square, direction)
    count = 0
    case direction
    when 'rank'
      start_rank = start_square[1]
      end_rank = end_square[1]
      if start_rank < end_rank
        start_rank.upto(end_rank) { |_rank| count += 1 }
      elsif start_rank > end_rank
        start_rank.downto(end_rank) { |_rank| count += 1 }
      end
    when 'file'
      start_file = start_square[0].ord
      end_file = end_square[0].ord
      if start_file < end_file
        start_file.upto(end_file) { |_rank| count += 1 }
      elsif start_file > end_file
        start_file.downto(end_file) { |_rank| count += 1 }
      end
    end
    count
  end

  def diagonal_path_empty?(direction, start_square, end_square)
    start_file = start_square[0]
    end_file = end_square[0]
    add_or_substract_file = if start_file < end_file
                              :+
                            elsif start_file > end_file
                              :-
                            end
    add_or_substract_rank = case direction
                            when 'up' then :+
                            when 'down' then :-
                            end
    square = start_square
    square = [square[0].ord.public_send(add_or_substract_file, 1).chr, square[1].public_send(add_or_substract_rank, 1)]
    until square == end_square
      return false unless square_empty?(square)

      square = [square[0].ord.public_send(add_or_substract_file, 1).chr, square[1].public_send(add_or_substract_rank, 1)]
    end
    true
  end

  def square_empty?(square)
    @board[square].empty?
  end
end
