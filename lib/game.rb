require_relative 'board'
require_relative 'players'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'king'

# class for the command line chess game
class ChessGame
  def initialize
    @board = Board.new.board
    @board_for_display = Board.new.board_for_display
    @player1 = PlayerOne.new
    @player2 = PlayerTwo.new
    @knight = KnightMoves.new
    @pawn = PawnMoves.new
    @rook = RookMoves.new
    @bishop = BishopMoves.new
    @queen = QueenMoves.new
    @king = KingMoves.new
  end

  def introduction
    puts %{
      Welcome to the game of chess. To make a move, write the current
      position of your piece followed by the position you want your piece
      to go to, e.g. a2a4, e2e3, b2b4 etc. .
    }
  end

  def play_game
    player = 1
    loop do
      # if winner? || draw? || @game_ended
      #   end_message
      #   break
      # end

      case player
      when 1
        get_next_move(player1)
        player = 2
      when 2
        get_next_move(player2)
        player = 1
      end
    end
  end

  def draw?
    insufficient_material_draw?
  end

  def insufficient_material_draw?
    insufficient_white_pieces = insufficient_player_pieces?(@player1)
    insufficient_black_pieces =  insufficient_player_pieces?(@player2)
    insufficient_white_pieces && insufficient_black_pieces
  end

  def insufficient_player_pieces?(player)
    case player.player_pieces
    when player.lone_king, player.king_and_knight, player.king_and_bishop then true
    else false
    end
  end

  def get_next_move(player)
    puts 'Make your next move'
    next_move = gets.strip.downcase
    until valid_move?(next_move, player)
      puts 'Incorrect choice. Try again'
      next_move = gets.strip.downcase
    end
    make_move(next_move, player)
    puts @board_for_display
  end

  # next_move should look like this: "a2a4"
  def valid_move?(next_move, player)
    start_square = [next_move[0], next_move[1].to_i]
    end_square = [next_move[2], next_move[3].to_i]
    next_move.length == 4 &&
      @board.key?(start_square) &&
      @board.key?(end_square) &&
      !square_empty?(start_square) &&
      !piece_belongs_to_player?(end_square, player) &&
      piece_belongs_to_player?(start_square, player) &&
      # (
      legal_move?(start_square, end_square, player) 
      # || castling_move?(start_square, end_square, player))
  end

  # def castling_move?(start_square, end_square, player)
  #   true if player.king_moved == false && king_moves_2_places_horizontally?(start_square, end_square) && a method to check if that particular rook moved && the path between is empty?
  # end

  # def king_moves_2_places_horizontally?(start_square, end_square)
  #  case end_square
  #  when [(start_square[0].ord + 2).chr, end_square[1]], [(start_square[0].ord - 2).chr, end_square[1]] then true
  #  else false
  #  end
  # end

  def square_empty?(square)
    @board[square].empty?
  end

  # checks if a piece belongs to the player whose turn it currently is
  def piece_belongs_to_player?(square, player)
    piece = @board[square]
    player.player_pieces.key?(piece)
  end

  def legal_move?(start_square, end_square, player)
    piece = read_piece_name(start_square)
    piece.allowed_moves(start_square, end_square, player, @board).include?(end_square)
  end

  def read_piece_name(square)
    unicode_piece = @board[square]
    pieces = [@knight, @pawn, @rook, @bishop, @queen, @king]
    pieces.each { |piece| return piece if piece.equals_unicode_piece?(unicode_piece) }
  end

  def make_move(next_move, player)
    start_square = [next_move[0], next_move[1].to_i] # e.g. = ['a', 2]
    end_square = [next_move[2], next_move[3].to_i]
    unicode_piece = @board[start_square]
    remember_moved_king(player) if unicode_piece == @king
    remember_moved_rook(start_square, player) if unicode_piece == @rook
    update_opponents_pieces(end_square, player) if makes_a_capture?(end_square)
    update_board(start_square, end_square, unicode_piece)
    update_board_for_display(next_move, unicode_piece)
  end

  def remember_moved_king(player)
    player.king_moved = true
  end

  def remember_moved_rook(start_square, player)
    file = start_square[0]
    case file
    when 'a' then player.rook_a_moved = true
    when 'h' then player.rook_h_moved = true
    end
  end

  def makes_a_capture?(end_square)
    !square_empty?(end_square)
  end

  def update_board(start_square, end_square, unicode_piece)
    @board[end_square] = unicode_piece
    @board[start_square] = ''
  end

  def update_opponents_pieces(end_square, player)
    opponent = (player == @player1 ? @player2 : @player1)
    unicode_piece = @board[end_square]
    opponent.player_pieces[unicode_piece] -= 1
  end

  def update_board_for_display(next_move, unicode_piece)
    start_rank = next_move[1]
    start_file = next_move[0]
    end_rank = next_move[3]
    end_file = next_move[2]
    # place the piece on the new square:
    @board_for_display[@board_for_display.index(end_rank) + get_file_index(end_file)] = unicode_piece
    # empty the square where the piece was:
    @board_for_display[@board_for_display.index(start_rank) + get_file_index(start_file)] = ' '
  end

  # for @board_for_display:
  # reads the number of index places to add to the index of a particular rank, based on which file we want to visit
  def get_file_index(file)
    file_indexes = { 'a' => 4, 'b' => 9, 'c' => 14, 'd' => 19, 'e' => 24, 'f' => 29, 'g' => 34, 'h' => 39 }
    file_indexes[file]
  end
end
chess = ChessGame.new
# chess.
p chess.instance_variable_get(:@board)
puts chess.instance_variable_get(:@board_for_display)

player1 = chess.instance_variable_get(:@player1)
# player2 = chess.instance_variable_get(:@player2)
# chess.get_next_move(player1)
# chess.get_next_move(player2)
# chess.get_next_move(player1)
# chess.get_next_move(player2)
# chess.get_next_move(player1)
# chess.get_next_move(player2)
# p player2.player_pieces
# p chess.instance_variable_get(:@board)

# puts chess.instance_variable_get(:@board_for_display)

p chess.legal_move?(['a', 2], ['a', 4], player1)

# # p chess.read_piece_name(['b',1])
