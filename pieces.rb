require_relative 'board'
require_relative 'player.rb'

class Piece
  attr_reader :symbol, :pos, :color
  attr_accessor :moved, :pos
  def initialize (color, pos, board, moved = false)
    @color, @pos, @board, @moved = color, pos, board, moved
  end




end

class SlidingPiece < Piece
  def possible_moves(pos, direction)
    possible_moves = []
    offsets = []
    case direction
    when :diag
      offsets = [ [1, 1], [-1, 1], [1, -1], [-1, -1] ]
    when :lateral
      offsets = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]
    end
    offsets.each do |offset|
      possible_moves += @board.sliding_moves_helper(pos, offset, @color)
    end

    possible_moves
  end
end

class SteppingPiece < Piece
  attr_reader :color

  def initialize(color, pos, board, moved = false)
    super
    create_directions
  end

  def possible_moves
    possible_moves = []
    @possible_directions.each do |offset|
      possible_moves += @board.stepping_moves_helper(pos, offset, @color )
    end

    possible_moves
  end
end


#Sliding pieces
class Rook < SlidingPiece
  def initialize(color, pos, board, moved = false)
    super
    @symbol = "\u265C"
  end

  def possible_moves
    super(@pos, :lateral)
  end
end

class Bishop < SlidingPiece
  def initialize(color, pos, board, moved = false)
    super
    @symbol = "\u265D"
  end

  def possible_moves
    super(@pos, :diag)
  end
end

class Queen < SlidingPiece
  def initialize(color, pos, board, moved = false)
    super
    @symbol = "\u265B"
  end

  def possible_moves
    result = super(@pos, :lateral)
    result +=  super(@pos, :diag)
  end
end

#Stepping pieces
class King < SteppingPiece

  def initialize(color, pos, board, moved = false)
    super
    @symbol = "\u265A"
  end

  def create_directions
    @possible_directions = [
      [1,1], [1,-1], [-1, -1], [-1, 1],
      [0,1], [0, -1], [1, 0], [-1, 0]
    ]
  end

end

class Pawn < SteppingPiece
  attr_reader :direction, :color

  def initialize(color, pos, board, moved = false)
    super
    @symbol = "\u265F"
  end

  def create_directions
    if color == :black
      @direction = 1
    else
      @direction = -1
    end
  end

  def possible_moves
    @board.pawn_moves_helper(pos, direction, color, moved)
  end


end

class Knight < SteppingPiece
  MOVE_DIRS = []
  def initialize(color, pos, board, moved = false)
    super
    @symbol = "\u265E"
  end

  def move_dirs
    MOVE_DIRS
  end

  def create_directions
    @possible_directions = [
      [2, 1], [2,-1], [1, 2], [1, -2],
      [-1, 2], [-1, -2], [-2, 1], [-2, -1]
    ]
  end
end


if __FILE__ == $PROGRAM_NAME
  k = Knight.new(:white, nil, nil)
  p k.symbol
end
