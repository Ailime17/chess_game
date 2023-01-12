files = %w[board players knight pawn queen king special_moves bot yaml_chess output]
files.each do |file|
  require_relative file
end

# class for the command line chess game
class ChessGame
  include Board
  include SpecialMoves
  include Bot
  include YamlChessGame
  include Messages

  def initialize
    @board = make_board
    @board_for_display = make_board_for_display
    @player1 = PlayerOne.new
    @player2 = PlayerTwo.new
    @knight = KnightMoves.new
    @pawn = PawnMoves.new
    @rook = RookMoves.new
    @bishop = BishopMoves.new
    @queen = QueenMoves.new
    @king = KingMoves.new
  end

  def play_game
    @player_number = 1
    start_new_game_or_continue_previous_session
    loop do
      break if checkmate? || draw? || @game_exited

      case @player_number
      when 1
        player_turn(@player1)
        @player_number = 2
      when 2
        player_turn(@player2)
        @player_number = 1
      end
    end
    display_end_message
  end

  private

  def start_new_game_or_continue_previous_session
    display_chess_board
    introduce_game
    ask_to_open_saved_game if File.exist?('saved_yaml/saved_game.yaml')
    if @player_opens_saved_game
      open_saved_game
      display_chess_board
    else
      set_up_players
    end
    complete_introduction
  end

  def set_up_players
    ask_about_opponent
    opponent_answer = get_answer_about_opponent
    @bot_activated = opponent_answer == 'y'
    inform_of_great_choice
  end

  def get_answer_about_opponent
    opponent_answer = gets.strip.downcase
    answers = %w[y n]
    until answers.include?(opponent_answer)
      wrong_opponent_answer_so_ask_again
      opponent_answer = gets.strip.downcase
    end
    opponent_answer
  end

  def checkmate?
    king_is_in_checkmate?(@player1) || king_is_in_checkmate?(@player2)
  end

  def king_is_in_checkmate?(player)
    king_is_in_check?(player) && player_has_no_legal_moves?(player)
  end

  def player_has_no_legal_moves?(player)
    @board.each_key do |square|
      next unless piece_belongs_to_player?(square, player)

      @board.each_key do |end_square|
        next if piece_belongs_to_player?(end_square, player)

        return false if legal_move?(square, end_square, player)
      end
    end
  end

  def draw?
    insufficient_material_draw?
    stalemate?
  end

  def insufficient_material_draw?
    insufficient_white_pieces = insufficient_player_pieces?(@player1)
    insufficient_black_pieces = insufficient_player_pieces?(@player2)
    (insufficient_white_pieces && insufficient_black_pieces) || one_player_has_lone_king
  end

  def one_player_has_lone_king
    @player1.player_pieces == @player1.lone_king || @player2.player_pieces == @player2.lone_king
  end

  def insufficient_player_pieces?(player)
    case player.player_pieces
    when player.lone_king, player.king_and_knight, player.king_and_bishop then true
    else false
    end
  end

  def stalemate?
    player_not_in_check_and_has_no_legal_moves?(@player1) ||
      player_not_in_check_and_has_no_legal_moves?(@player2)
  end

  def player_not_in_check_and_has_no_legal_moves?(player)
    !king_is_in_check?(player) && player_has_no_legal_moves?(player)
  end

  def player_turn(player)
    next_move = if @bot_activated && player == @player2
                  random_legal_move
                else
                  get_next_move(player)
                end
    return safely_exit_game if player_exits_game?(next_move)

    return save_and_continue_game(player) if player_saves_game?(next_move)

    make_move(next_move, player)
    @most_recent_move = next_move
    display_chess_board
  end

  def get_next_move(player)
    ask_for_next_move(player)
    next_move = gets.strip.downcase
    until player_entered_valid_input?(next_move, player)
      wrong_move_input_so_ask_again
      next_move = gets.strip.downcase
    end
    next_move
  end

  def player_entered_valid_input?(next_move, player)
    valid_move?(next_move, player) ||
      player_exits_game?(next_move) ||
      player_saves_game?(next_move)
  end

  def player_exits_game?(input)
    input == 'x'
  end

  def player_saves_game?(input)
    input == 's'
  end

  def safely_exit_game
    @game_exited = true
    ask_to_save_game
  end

  def save_and_continue_game(player)
    save_game
    inform_of_saved_game
    player_turn(player)
  end

  # (next_move should look like this: "a2a4")
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
    (piece.allowed_moves(start_square, end_square, player, @board).include?(end_square) ||
      castling_move?(start_square, end_square, player, piece) ||
      en_passant?(start_square, end_square, player, piece)) &&
      !move_puts_the_king_in_check?(start_square, end_square, player)
  end

  def read_piece_name(square, board = @board)
    unicode_piece = board[square]
    pieces = [@knight, @pawn, @rook, @bishop, @queen, @king]
    pieces.each { |piece| return piece if piece.equals_unicode_piece?(unicode_piece) }
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
    mock_board = create_mock_board
    mock_board[end_square] = mock_board[start_square]
    mock_board[start_square] = ''
    king_is_in_check?(player, mock_board)
  end

  def make_move(next_move, player)
    start_square = [next_move[0], next_move[1].to_i] # e.g. = ['a', 2]
    end_square = [next_move[2], next_move[3].to_i]
    unicode_piece = @board[start_square]
    return perform_en_passant(start_square, end_square, player, unicode_piece) if en_passant?(start_square, end_square, player)

    return perform_castling(start_square, end_square, player) if castling_move?(start_square, end_square, player)

    complete_standard_actions_for_a_standard_move(start_square, end_square, player, unicode_piece)
    promote_pawn(end_square, player) if promotion?(end_square, player)
    inform_of_move_bot_made_if_bot_is_activated(next_move, player)
  end

  def complete_standard_actions_for_a_standard_move(start_square, end_square, player, unicode_piece)
    remember_moved_king(player) if @king.equals_unicode_piece?(unicode_piece)
    remember_moved_rook(start_square, player) if @rook.equals_unicode_piece?(unicode_piece)
    update_opponents_pieces(end_square, player) if makes_a_capture?(end_square)
    update_both_boards(start_square, end_square, unicode_piece)
  end

  def perform_en_passant(start_square, end_square, player, unicode_piece)
    update_opponents_pieces(@most_recent_end_square, player)
    # for the player pawn:
    update_both_boards(start_square, end_square, unicode_piece)
    # for the opponent pawn:
    update_board(@most_recent_end_square, @most_recent_end_square, '')
    update_board_for_display(@most_recent_end_square, @most_recent_end_square, ' ')
  end

  def update_opponents_pieces(end_square, player)
    opponent = (player == @player1 ? @player2 : @player1)
    unicode_piece = @board[end_square]
    opponent.player_pieces[unicode_piece] -= 1
  end

  def perform_castling(start_square, end_square, player)
    king_square = start_square
    king_piece = @board[king_square]
    if king_moved_towards_rook_h?(start_square, end_square)
      rook_square = player.rook_square('h')
      square_next_to_king = [(king_square[0].ord + 1).chr, king_square[1]]
    else
      rook_square = player.rook_square('a')
      square_next_to_king = [(king_square[0].ord - 1).chr, king_square[1]]
    end
    rook_piece = @board[rook_square]
    perform_actions_for_castling(end_square, player, king_square, king_piece, rook_square, square_next_to_king, rook_piece)
  end

  def perform_actions_for_castling(end_square, player, king_square, king_piece, rook_square, square_next_to_king, rook_piece)
    update_both_boards(king_square, end_square, king_piece) # with king
    update_both_boards(rook_square, square_next_to_king, rook_piece) # with rook
    remember_moved_rook(rook_square, player)
    remember_moved_king(player)
  end

  def remember_moved_rook(start_square, player)
    file = start_square[0]
    case file
    when 'a' then player.rook_a_moved = true
    when 'h' then player.rook_h_moved = true
    end
  end

  def remember_moved_king(player)
    player.king_moved = true
  end

  def makes_a_capture?(end_square)
    !square_empty?(end_square)
  end

  def promote_pawn(end_square, player)
    piece_to_promote_to = get_promotion_answer
    new_unicode_piece = case piece_to_promote_to
                        when 'queen' then player.queen
                        when 'knight' then player.knight
                        when 'rook' then player.rook
                        when 'bishop' then player.bishop
                        end
    update_player_pieces_with_pawn_promotion(player, new_unicode_piece)
    update_both_boards_with_pawn_promotion(end_square, new_unicode_piece)
  end

  def get_promotion_answer
    inform_and_ask_about_pawn_promotion
    answers = %w[queen knight rook bishop]
    answer = gets.strip.downcase
    until answers.include?(answer)
      wrong_promotion_answer_so_ask_again
      answer = gets.strip.downcase
    end
    answer
  end

  def update_player_pieces_with_pawn_promotion(player, new_unicode_piece)
    pawn_piece = player.pawn
    player.player_pieces[pawn_piece] -= 1
    player.player_pieces[new_unicode_piece] += 1
  end

  def update_both_boards_with_pawn_promotion(end_square, new_unicode_piece)
    @board[end_square] = new_unicode_piece
    update_board_for_display(end_square, end_square, new_unicode_piece)
  end
end
chess = ChessGame.new
chess.play_game
# player1 = chess.instance_variable_get(:@player1)
# player2 = chess.instance_variable_get(:@player2)
# chess.make_move('e2e4', player1)
# chess.make_move('f7f5', player2)
# chess.make_move('e4f5', player1)
# chess.make_move('e7e6', player2)
# chess.make_move('b2b4', player1)
# chess.player_turn(player1)
# chess.player_turn(player2)
# p chess.castling_move?(['e', 1], ['g', 1], player1)
# p player2.player_pieces
# p chess.move_puts_the_king_in_check?(['e', 2], ['e', 3], player1)
# p chess.legal_move?(['a', 2], ['a', 4], player1)
# p chess.read_piece_name(['b',1])
# p chess.king_is_in_check?(player1)
# p chess.king_is_in_check?(player2)
# p chess.promote_pawn(['g', 1], player2)
# p player2.player_pieces
# p chess.instance_variable_get(:@board)
# puts chess.instance_variable_get(:@board_for_display)