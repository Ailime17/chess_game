# class for the rook pieces
class RookMoves
  def initialize
    @visual_pieces = ["\u2656", "\u265C"]
  end

  # method used by ChessGame class to find out the piece's name by comparing unicodes
  def equals_unicode_piece?(unicode_piece)
    @visual_pieces.include?(unicode_piece)
  end
end
