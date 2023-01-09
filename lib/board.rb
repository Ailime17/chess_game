require_relative 'players'

# class that sets up the boards
class Board
  attr_reader :board, :board_for_display

  def initialize
    @white = PlayerOne.new
    @black = PlayerTwo.new
    @board = make_board
    @board_for_display = make_board_for_display
  end

  # files are columns & ranks are rows on the board
  def make_board
    board = Hash.new(0)
    'a'.upto('h') do |file|
      1.upto(8) do |rank|
        if (3..6).include?(rank)
          board[[file, rank]] = ''
        else
          place_a_piece(board, file, rank)
        end
      end
    end
    board
  end

  def place_a_piece(board, file, rank)
    board[[file, rank]] =
      case rank
      when 2
        @white.pawn
      when 7
        @black.pawn
      when 1
        if %w[a h].include?(file)
          @white.rook
        elsif %w[b g].include?(file)
          @white.knight
        elsif %w[c f].include?(file)
          @white.bishop
        elsif file == 'd'
          @white.queen
        elsif file == 'e'
          @white.king
        end
      when 8
        if %w[a h].include?(file)
          @black.rook
        elsif %w[b g].include?(file)
          @black.knight
        elsif %w[c f].include?(file)
          @black.bishop
        elsif file == 'd'
          @black.queen
        elsif file == 'e'
          @black.king
        end
      end
  end

  def make_board_for_display
    board = %{
         ________________________________________
        |                                       |\\
      8 | br | bn | bb | bq | bk | bb | bn | br ||
        |---------------------------------------||
      7 | bp | bp | bp | bp | bp | bp | bp | bp ||
        |---------------------------------------||
      6 |    |    |    |    |    |    |    |    ||
        |---------------------------------------||
      5 |    |    |    |    |    |    |    |    ||
        |---------------------------------------||
      4 |    |    |    |    |    |    |    |    ||
        |---------------------------------------||
      3 |    |    |    |    |    |    |    |    ||
        |---------------------------------------||
      2 | wp | wp | wp | wp | wp | wp | wp | wp ||
        |---------------------------------------||
      1 | wr | wn | wb | wq | wk | wb | wn | wr ||
        |_______________________________________||
         \\______________________________________\\|
           a    b    c    d    e    f    g    h
    }
    place_pieces_on_board(board)
    make_empty_black_squares_visibly_black(board)
    board
  end

  def place_pieces_on_board(board)
    [['wq',@white.queen], ['bq',@black.queen], ['wk',@white.king], ['bk',@black.king],
     ['wr',@white.rook], ['br',@black.rook], ['wn',@white.knight], ['bn',@black.knight],
     ['wp',@white.pawn], ['bp',@black.pawn], ['wb',@white.bishop], ['bb',@black.bishop]].each do |pair|
      board.gsub!(pair[0], "#{pair[1]} ")
    end
  end

  def read_squares(color_of_squares)
    squares = []
    colors = ['white', 'black'].cycle
    ('a'..'h').each do |file|
      square_color = colors.next
      (1..8).each do |rank|
        square_color = colors.next
        squares << [file, rank] if color_of_squares == square_color
      end
    end
    squares
  end

  def make_empty_black_squares_visibly_black(board)
    unicode_black_square = "\u2605"
    black_squares = read_squares('black')
    black_squares.each do |square|
      rank = square[1].to_s
      file = square[0]
      board[board.index(rank) + get_file_index(file)] = unicode_black_square if board[board.index(rank) + get_file_index(file)] == ' '
    end
  end

  # for @board_for_display:
  # reads the number of index places to add to the index of a particular rank, based on which file we want to visit
  def get_file_index(file)
    file_indexes = { 'a' => 4, 'b' => 9, 'c' => 14, 'd' => 19, 'e' => 24, 'f' => 29, 'g' => 34, 'h' => 39 }
    file_indexes[file]
  end
end
