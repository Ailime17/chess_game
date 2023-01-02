# class for the king pieces
class KingMoves
  def initialize
    @visual_pieces = ["\u2654", "\u265A"]
  end

  # method used by ChessGame class to find out the piece's name by comparing unicodes
  def equals_unicode_piece?(unicode_piece)
    @visual_pieces.include?(unicode_piece)
  end

  def allowed_moves(start_square, _end_square, _player, board)
    @board = board
    file = start_square[0]
    rank = start_square[1]
    allowed_moves = [] + diagonal_moves(file, rank) + horizontal_moves(file, rank) + vertical_moves(file, rank)
    allowed_moves.select! { @board.include?(allowed_move) }
    allowed_moves
  end

  def diagonal_moves(file, rank)
    [
      [(file.ord - 1).chr, rank + 1],
      [(file.ord - 1).chr, rank - 1],
      [(file.ord + 1).chr, rank + 1],
      [(file.ord + 1).chr, rank - 1]
    ]
  end

  def horizontal_moves(file, rank)
    [
      [(file.ord + 1).chr, rank],
      [(file.ord - 1).chr, rank]
    ]
  end

  def vertical_moves(file, rank)
    [
      [file, rank + 1],
      [file, rank - 1]
    ]
  end
end
