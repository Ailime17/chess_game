# class for the knight pieces
class KnightMoves
  def initialize
    @visual_pieces = ["\u2658", "\u265E"]
  end

  # method used by ChessGame class to find out the piece's name by comparing unicodes
  def equals_unicode_piece?(unicode_piece)
    @visual_pieces.include?(unicode_piece)
  end

  # the knight moves in an L-shaped way & can jump over pieces
  def allowed_moves(start_square, _end_square, _player, board)
    @board = board
    allowed_moves = [
      [(start_square[0].ord + 1).chr, start_square[1] + 2], # up,up,right
      [(start_square[0].ord - 1).chr, start_square[1] + 2], # etc.
      [(start_square[0].ord + 1).chr, start_square[1] - 2],
      [(start_square[0].ord - 1).chr, start_square[1] - 2],
      [(start_square[0].ord + 2).chr, start_square[1] + 1],
      [(start_square[0].ord + 2).chr, start_square[1] - 1],
      [(start_square[0].ord - 2).chr, start_square[1] + 1],
      [(start_square[0].ord - 2).chr, start_square[1] - 1]
    ]
    allowed_moves.select! { |move| @board.key?(move) }
    allowed_moves
  end
end
# knight = KnightMoves.new
# p knight.allowed_moves(['d', 4])