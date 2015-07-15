require_relative 'pieces.rb'
require_relative 'board.rb'
require_relative 'player.rb'
require 'colorize'

class Game
  # [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
  STARTING_POSITIONS_BLACK = {
    queen: [[0, 3]],
    king: [[0, 4]],
    rook: [[0, 0], [0, 7]],
    knight: [[0, 1], [0, 6]],
    bishop: [[0, 2], [0, 5]]
  }

  STARTING_POSITIONS_WHITE = {
    queen: [[7, 3]],
    king: [[7, 4]],
    rook: [[7, 0], [7, 7]],
    knight: [[7, 1], [7, 6]],
    bishop: [[7, 2], [7, 5]]
  }

  def initialize
    @board = Board.new
    @player1 = Player.new(:white)
    @player2 = Player.new(:black)
    create_pieces(:black)
    create_pieces(:white)
  end

  def create_pieces(color)
    if color == :black
      starting_positions = STARTING_POSITIONS_BLACK
      pawn_row = 1
    else
      starting_positions = STARTING_POSITIONS_WHITE
      pawn_row = 6
    end

    starting_positions.each do |piece_type, positions|
      positions.each do |position|
        @board[position] = create_piece(piece_type, color, position)
      end
    end
    #create pawns
    (0..7).each do |column|
      pos = [pawn_row, column]
      @board[pos] = Pawn.new(color, pos, @board)
    end
  end

  def create_piece(piece_type, color, pos)
    case piece_type
    when :queen
      Queen.new(color, pos, @board)
    when :king
      King.new(color, pos, @board)
    when :knight
      Knight.new(color, pos, @board)
    when :bishop
      Bishop.new(color, pos, @board)
    when :rook
      Rook.new(color, pos, @board)
    end
  end

  def show_board
    @board
  end

  def play
    loop do
      puts "Red's Turn"
      take_turn(@player1)
      puts "Blue's Turn"
      take_turn(@player2)
    end
  end

  def take_turn(player)
    if @board.in_check?(player.color)
      p player.color
      puts "#{player.color.capitalize}'s in Check!!!!"
    end

    begin
      @board.render
      move = player.prompt
      raise unless @board[move[0]].color == player.color
      @board.move(*move)
      rescue
        puts "Invalid Move!!!"
        retry
    end

  end

end



if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
  # board = game.show_board
  # board.render
  # piece = board[[1, 1]]
  # board.render
  # board.move(piece.pos, [3, 1])
  # board.render
  # board.move([7,1], [5,2])
  # board.render
end
