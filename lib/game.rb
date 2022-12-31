require_relative 'board'
require_relative 'players'
require_relative 'knight'
require_relative 'pawn'
require_relative 'rook'

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
      # break if winner? || draw? || @game_ended

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
      legal_move?(start_square, end_square, player)
  end

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
    # when ("\u2655", "\u265B") then @queen
    # when ("\u2654", "\u265A") then @king
    # when ("\u2657", "\u265D") then @bishop
    pieces = [@knight, @pawn, @rook, @bishop, @queen, @king]
    pieces.each do |piece| # change to select once all symbols have classes
      return piece if piece.equals_unicode_piece?(unicode_piece)
    end
  end

  def make_move(next_move, player)
    start_square = [next_move[0], next_move[1].to_i] # e.g. = ['a', 2]
    end_square = [next_move[2], next_move[3].to_i]
    unicode_piece = @board[start_square]
    update_opponents_pieces(end_square, player) if makes_a_capture?(end_square)
    update_board(start_square, end_square, unicode_piece)
    update_board_for_display(next_move, unicode_piece)
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
player2 = chess.instance_variable_get(:@player2)
chess.get_next_move(player1)
chess.get_next_move(player2)
chess.get_next_move(player1)
chess.get_next_move(player2)
chess.get_next_move(player1)
chess.get_next_move(player2)
# p player2.player_pieces
# p chess.instance_variable_get(:@board)

# puts chess.instance_variable_get(:@board_for_display)

# # p chess.legal_move?(['a', 2], ['a', 4], player1)

# # p chess.read_piece_name(['b',1])
