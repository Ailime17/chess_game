require_relative 'rook'
require_relative 'bishop'

# class for the queen pieces
class QueenMoves
  def initialize
    @visual_pieces = ["\u2655", "\u265B"]
  end

  # method used by ChessGame class to find out the piece's name by comparing unicodes
  def equals_unicode_piece?(unicode_piece)
    @visual_pieces.include?(unicode_piece)
  end

  def allowed_moves(start_square, end_square, player, board)
    # preserving memory space version, because allowed_moves doesn't include all possible end_squares, only the one end_square if legal
    RookMoves.new.allowed_moves(start_square, end_square, player, board) + BishopMoves.new.allowed_moves(start_square, end_square, player, board)
  end
end
