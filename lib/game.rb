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
    introduction
    puts @board_for_display
    player = 1
    loop do
      # if winner? || draw? || @game_ended
      #   end_message
      #   break
      # end

      case player
      when 1
        player_turn(@player1)
        player = 2
      when 2
        player_turn(@player2)
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

  def player_turn(player)
    next_move = get_next_move(player)
    make_move(next_move, player)
    @most_recent_move = next_move
    p @board
    puts @board_for_display
  end

  def get_next_move(player)
    color = (player.color == 'white' ? 'White' : 'Black')
    puts "#{color} player, Make your next move"
    print '> '
    next_move = gets.strip.downcase
    until valid_move?(next_move, player)
      puts 'Incorrect choice. Try again'
      print '> '
      next_move = gets.strip.downcase
    end
    next_move
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

  def castling_move?(start_square, end_square, player, piece = read_piece_name(start_square))
    piece == @king &&
      !king_is_in_check?(player) &&
      player.king_moved == false &&
      king_moves_2_places_horizontally?(start_square, end_square) &&
      rook_has_not_moved?(start_square, end_square, player) &&
      path_between_king_and_rook_empty?(start_square, end_square, player) #&&
      # !king_will_be_in_check_during_castling?(start_square, end_square, player) #&&
      # !king_will_be_in_check_after_castling?(start_square, end_square, player)
  end

  def king_moves_2_places_horizontally?(start_square, end_square)
    case end_square
    when [(start_square[0].ord + 2).chr, start_square[1]], [(start_square[0].ord - 2).chr, start_square[1]] then true
    else false
    end
  end

  def rook_has_not_moved?(start_square, end_square, player)
    if king_moved_towards_rook_h?(start_square, end_square)
      player.rook_h_moved == false
    else
      player.rook_a_moved == false
    end
  end

  def path_between_king_and_rook_empty?(start_square, end_square, player)
    a_rook = (player == @player1 ? ['a', 1] : ['a', 8])
    h_rook = (player == @player1 ? ['h', 1] : ['h', 8])
    if king_moved_towards_rook_h?(start_square, end_square)
      king_to_rook_path_empty?(start_square, h_rook, :+)
    else
      king_to_rook_path_empty?(start_square, a_rook, :-)
    end
  end

  def king_to_rook_path_empty?(start_square, end_square, add_or_substract)
    square = [start_square[0], start_square[1]]
    square[0] = square[0].ord.public_send(add_or_substract, 1).chr
    until square == end_square
      return false unless square_empty?(square)

      square[0] = square[0].ord.public_send(add_or_substract, 1).chr
    end
    true
  end

  # def king_will_be_in_check_during_castling?(start_square, end_square, player)
  #   add_or_substract_file =  if king_moved_towards_rook_h?(start_square, end_square)
  #                               :+
  #                            else
  #                               :-
  #                            end
  #   square = [start_square[0], start_square[1]]
  #   square[0] = square[0].ord.public_send(add_or_substract, 1).chr
  #   loop do
  #     return true if move_puts_the_king_in_check?(start_square, square, player)

  #     break if square == end_square
  #     square[0] = square[0].ord.public_send(add_or_substract, 1).chr
  #   end
  #   false
  # end

  def square_empty?(square, board = @board)
    board[square].empty?
  end

  # checks if a piece belongs to the player whose turn it currently is
  def piece_belongs_to_player?(square, player, board = @board)
    piece = board[square]
    player.player_pieces.key?(piece)
  end

  def legal_move?(start_square, end_square, player)
    piece = read_piece_name(start_square)
    piece.allowed_moves(start_square, end_square, player, @board).include?(end_square) ||
      castling_move?(start_square, end_square, player, piece) ||
      en_passant?(start_square, end_square, player, piece)
  end

  def read_piece_name(square, board = @board)
    unicode_piece = board[square]
    pieces = [@knight, @pawn, @rook, @bishop, @queen, @king]
    pieces.each { |piece| return piece if piece.equals_unicode_piece?(unicode_piece) }
  end

  # (the order of methods is very important in make_move)
  def make_move(next_move, player)
    start_square = [next_move[0], next_move[1].to_i] # e.g. = ['a', 2]
    end_square = [next_move[2], next_move[3].to_i]
    unicode_piece = @board[start_square]
    return illegal_move_message(player, true) if move_puts_the_king_in_check?(start_square, end_square, player) && king_is_in_check?(player)

    return illegal_move_message(player, false) if move_puts_the_king_in_check?(start_square, end_square, player)

    return perform_en_passant(start_square, end_square, player, unicode_piece) if en_passant?(start_square, end_square, player)

    return perform_castling(start_square, end_square, player) if castling_move?(start_square, end_square, player)

    # perform standard actions:
    remember_moved_king(player) if @king.equals_unicode_piece?(unicode_piece)
    remember_moved_rook(start_square, player) if @rook.equals_unicode_piece?(unicode_piece)
    update_opponents_pieces(end_square, player) if makes_a_capture?(end_square)
    update_both_boards(start_square, end_square, unicode_piece)
    promote_pawn(end_square, player) if promotion?(end_square, player)
  end

  def illegal_move_message(player, has_to_escape_check)
    case has_to_escape_check
    when true then puts "Illegal move - doesn't escape king from check. Try again:"
    when false then puts 'Illegal move - puts the king in check. Try again:'
    end
    player_turn(player)
  end

  def king_is_in_check?(player, board = @board)
    king_unicode = player.king
    king_square = board.key(king_unicode)
    opponent = (player == @player1 ? @player2 : @player1)

    board.each_key do |square|
      next if square_empty?(square, board) || piece_belongs_to_player?(square, player, board)

      piece = read_piece_name(square, board)
      return true if piece.allowed_moves(square, king_square, opponent, board).include?(king_square)
    end
    false
  end

  def move_puts_the_king_in_check?(start_square, end_square, player)
    mock_board = Hash.new(0)
    @board.each do |square, piece|
      mock_board[square] = piece
    end
    mock_board[end_square] = mock_board[start_square]
    mock_board[start_square] = ''
    king_is_in_check?(player, mock_board)
  end

  def promotion?(end_square, player)
    unicode_piece = @board[end_square]
    @pawn.equals_unicode_piece?(unicode_piece) &&
      pawn_reached_the_end_of_the_board?(end_square, player)
  end

  def pawn_reached_the_end_of_the_board?(end_square, player)
    rank = end_square[1]
    (rank == 8 && player == @player1) || (rank == 1 && player == @player2)
  end

  def promote_pawn(end_square, player)
    piece_to_promote_to = get_promotion_answer
    new_unicode_piece = case piece_to_promote_to
                        when 'queen' then player.queen
                        when 'knight' then player.knight
                        when 'rook' then player.rook
                        when 'bishop' then player.bishop
                        end
    # update player_pieces:
    pawn_piece = player.pawn
    player.player_pieces[pawn_piece] -= 1
    player.player_pieces[new_unicode_piece] += 1
    # update both boards:
    @board[end_square] = new_unicode_piece
    update_board_for_display(end_square, end_square, new_unicode_piece)
  end

  def get_promotion_answer
    answers = %w[queen knight rook bishop]
    puts %{
    Good job! Choose a piece you want your pawn to be promoted to:
    Queen / Knight / Rook / Bishop
    }
    print '> '
    answer = gets.strip.downcase
    until answers.include?(answer)
      puts %{
      Try again. Choose a piece you want your pawn to be promoted to:
      Queen / Knight / Rook / Bishop
      }
      print '> '
      answer = gets.strip.downcase
    end
    answer
  end

  def perform_castling(start_square, end_square, player)
    a_rook = (player == @player1 ? ['a', 1] : ['a', 8])
    h_rook = (player == @player1 ? ['h', 1] : ['h', 8])
    king_square = start_square
    king_piece = @board[king_square]
    if king_moved_towards_rook_h?(start_square, end_square)
      rook_square = h_rook
      square_next_to_king = [(king_square[0].ord + 1).chr, king_square[1]]
    else
      rook_square = a_rook
      square_next_to_king = [(king_square[0].ord - 1).chr, king_square[1]]
    end
    rook_piece = @board[rook_square]
    update_both_boards(king_square, end_square, king_piece) # with king
    update_both_boards(rook_square, square_next_to_king, rook_piece) # with rook
    remember_moved_rook(rook_square, player)
    remember_moved_king(player)
  end

  def update_both_boards(start_square, end_square, unicode_piece)
    update_board(start_square, end_square, unicode_piece)
    update_board_for_display(start_square, end_square, unicode_piece)
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

  def opponent_pawn_just_moved_two_places?
    start_rank = @most_recent_start_square[1]
    end_rank = @most_recent_end_square[1]

    read_piece_name(@most_recent_end_square) == @pawn &&
      (end_rank == start_rank + 2 || end_rank == start_rank - 2)
  end

  def opponent_pawn_just_sat_next_to_player_pawn?(start_square)
    (@most_recent_end_square[0] == (start_square[0].ord + 1).chr ||
      @most_recent_end_square[0] == (start_square[0].ord - 1).chr) &&
      @most_recent_end_square[1] == start_square[1]
  end

  def player_pawn_moves_where_the_opponent_pawn_would_be_if_it_moved_one_place?(current_player, end_square)
    add_or_substract_opponent_rank = (current_player == @player1 ? :- : :+)
    end_square == [@most_recent_start_square[0], @most_recent_start_square[1].public_send(add_or_substract_opponent_rank, 1)]
  end

  def en_passant?(start_square, end_square, player, player_piece = read_piece_name(start_square))
    return false if @most_recent_move.nil?

    @most_recent_start_square = [@most_recent_move[0], @most_recent_move[1].to_i]
    @most_recent_end_square = [@most_recent_move[2], @most_recent_move[3].to_i]

    player_piece == @pawn &&
      opponent_pawn_just_moved_two_places? &&
      opponent_pawn_just_sat_next_to_player_pawn?(start_square) &&
      player_pawn_moves_where_the_opponent_pawn_would_be_if_it_moved_one_place?(player, end_square)
  end

  def perform_en_passant(start_square, end_square, player, unicode_piece)
    update_opponents_pieces(@most_recent_end_square, player)
    # for the player pawn:
    update_both_boards(start_square, end_square, unicode_piece)
    # for the opponent pawn:
    update_board(@most_recent_end_square, @most_recent_end_square, '')
    update_board_for_display(@most_recent_end_square, @most_recent_end_square, ' ')
  end

  def makes_a_capture?(end_square)
    !square_empty?(end_square)
  end

  def king_moved_towards_rook_h?(start_square, end_square)
    end_square[0] > start_square[0]
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

  def update_board_for_display(start_square, end_square, unicode_piece)
    start_rank = start_square[1].to_s
    start_file = start_square[0]
    end_rank = end_square[1].to_s
    end_file = end_square[0]
    # empty the square where the piece was:
    @board_for_display[@board_for_display.index(start_rank) + get_file_index(start_file)] = ' '
    # place the piece on the new square:
    @board_for_display[@board_for_display.index(end_rank) + get_file_index(end_file)] = unicode_piece
  end

  # for @board_for_display:
  # reads the number of index places to add to the index of a particular rank, based on which file we want to visit
  def get_file_index(file)
    file_indexes = { 'a' => 4, 'b' => 9, 'c' => 14, 'd' => 19, 'e' => 24, 'f' => 29, 'g' => 34, 'h' => 39 }
    file_indexes[file]
  end
end
chess = ChessGame.new
# p chess.instance_variable_get(:@board)
# puts chess.instance_variable_get(:@board_for_display)
chess.play_game
# player1 = chess.instance_variable_get(:@player1)
# player2 = chess.instance_variable_get(:@player2)
# chess.make_move('e2e4', player1)
# chess.make_move('f7f5', player2)
# chess.make_move('e4f5', player1)
# chess.make_move('e7e6', player2)
# chess.make_move('b2b4', player1)
# chess.make_move('d8g5', player2)
# chess.make_move('a2a4', player1)
# chess.make_move('g5e3', player2)
# chess.make_move('e2e3', player1)
# chess.player_turn(player2)
# chess.player_turn(player1)
# chess.player_turn(player2)
# chess.player_turn(player1)
# chess.player_turn(player2)
# chess.player_turn(player1)
# chess.player_turn(player2)
# chess.player_turn(player1)
# chess.player_turn(player2)
# # p chess.castling_move?(['e', 1], ['g', 1], player1)
# p player2.player_pieces
# p chess.instance_variable_get(:@board)
# p chess.move_puts_the_king_in_check?(['e', 2], ['e', 3], player1)

# puts chess.instance_variable_get(:@board_for_display)

# p chess.legal_move?(['a', 2], ['a', 4], player1)

# # p chess.read_piece_name(['b',1])
# chess.complete_castling(['e', 1], ['c', 1], player1)

# p chess.king_is_in_check?(player1)
# p chess.king_is_in_check?(player2)
# p chess.promote_pawn(['g', 1], player2)
p chess.instance_variable_get(:@board)
# p player2.player_pieces
puts chess.instance_variable_get(:@board_for_display)