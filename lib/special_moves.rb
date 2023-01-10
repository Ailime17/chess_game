# module with methods for ChessGame class for checking if the move is a castling, en passant or promotion
module SpecialMoves
  # castling move:
  def castling_move?(start_square, end_square, player, piece = read_piece_name(start_square))
    piece == @king &&
      !king_is_in_check?(player) &&
      player.king_moved == false &&
      king_moves_2_places_horizontally?(start_square, end_square) &&
      rook_has_not_moved?(start_square, end_square, player) &&
      path_between_king_and_rook_empty?(start_square, end_square, player) &&
      !king_will_be_in_check_during_castling?(start_square, end_square, player) &&
      !king_will_be_in_check_after_castling?(start_square, end_square, player)
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

  def king_moved_towards_rook_h?(start_square, end_square)
    end_square[0] > start_square[0]
  end

  def path_between_king_and_rook_empty?(start_square, end_square, player)
    a_rook = (player == @player1 ? ['a', 1] : ['a', 8])
    h_rook = (player == @player1 ? ['h', 1] : ['h', 8])
    if king_moved_towards_rook_h?(start_square, end_square)
      end_sq = h_rook
      add_or_substract = :+
    else
      end_sq = a_rook
      add_or_substract = :-
    end
    square = [start_square[0], start_square[1]]
    square[0] = square[0].ord.public_send(add_or_substract, 1).chr
    until square == end_sq
      return false unless square_empty?(square)

      square[0] = square[0].ord.public_send(add_or_substract, 1).chr
    end
    true
  end

  def king_will_be_in_check_during_castling?(start_square, end_square, player)
    add_or_substract_file =  if king_moved_towards_rook_h?(start_square, end_square)
                                :+
                             else
                                :-
                             end
    square = [start_square[0], start_square[1]]
    square[0] = square[0].ord.public_send(add_or_substract_file, 1).chr
    loop do
      return true if move_puts_the_king_in_check?(start_square, square, player)

      break if square == end_square
      square[0] = square[0].ord.public_send(add_or_substract_file, 1).chr
    end
    false
  end

  def king_will_be_in_check_after_castling?(king_square, end_square, player)
    mock_board = create_mock_board
    mock_board[end_square] = mock_board[king_square]
    mock_board[king_square] = ''
    if king_moved_towards_rook_h?(king_square, end_square)
      num_of_squares_from_king_to_rook = 3
      add_or_substract_file =  :+
    else
      add_or_substract_file =  :-
      num_of_squares_from_king_to_rook = 4
    end
    new_rook_square = [king_square[0].ord.public_send(add_or_substract_file, 1).chr, king_square[1]]
    old_rook_square = [king_square[0].ord.public_send(add_or_substract_file, num_of_squares_from_king_to_rook).chr, king_square[1]]
    mock_board[new_rook_square] = mock_board[old_rook_square]
    mock_board[old_rook_square] = ''
    king_is_in_check?(player, mock_board)
  end

  def create_mock_board
    mock_board = Hash.new(0)
    @board.each do |square, piece|
      mock_board[square] = piece
    end
    mock_board
  end

  # en_passant:
  def en_passant?(start_square, end_square, player, player_piece = read_piece_name(start_square))
    return false if @most_recent_move.nil?

    @most_recent_start_square = [@most_recent_move[0], @most_recent_move[1].to_i]
    @most_recent_end_square = [@most_recent_move[2], @most_recent_move[3].to_i]

    player_piece == @pawn &&
      opponent_pawn_just_moved_two_places? &&
      opponent_pawn_just_sat_next_to_player_pawn?(start_square) &&
      player_pawn_moves_where_the_opponent_pawn_would_be_if_it_moved_one_place?(player, end_square)
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

  # promotion:
  def promotion?(end_square, player)
    unicode_piece = @board[end_square]
    @pawn.equals_unicode_piece?(unicode_piece) &&
      pawn_reached_the_end_of_the_board?(end_square, player)
  end

  def pawn_reached_the_end_of_the_board?(end_square, player)
    rank = end_square[1]
    (rank == 8 && player == @player1) || (rank == 1 && player == @player2)
  end
end
