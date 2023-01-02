# class for white pieces
class PlayerOne
  attr_reader :queen, :king, :rook, :knight, :bishop, :pawn, :color
  attr_accessor :player_pieces, :king_moved, :rook_a_moved, :rook_h_moved

  def initialize
    @color = 'white'
    @queen = "\u2655"
    @king = "\u2654"
    @rook = "\u2656"
    @knight = "\u2658"
    @bishop = "\u2657"
    @pawn = "\u2659"
    @player_pieces = { @queen => 1, @king => 1, @rook => 2, @knight => 2, @bishop => 2, @pawn => 8 }
    @king_moved = false
    @rook_a_moved = false
    @rook_h_moved = false
  end
end

# class for black pieces
class PlayerTwo
  attr_reader :queen, :king, :rook, :knight, :bishop, :pawn, :color
  attr_accessor :player_pieces, :king_moved, :rook_a_moved, :rook_h_moved

  def initialize
    @color = 'black'
    @queen = "\u265B"
    @king = "\u265A"
    @rook = "\u265C"
    @knight = "\u265E"
    @bishop = "\u265D"
    @pawn = "\u265F"
    @player_pieces = { @queen => 1, @king => 1, @rook => 2, @knight => 2, @bishop => 2, @pawn => 8 }
    @king_moved = false
    @rook_a_moved = false
    @rook_h_moved = false
  end
end

# class for bot black pieces
# class BotPlayer
# end