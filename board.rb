require_relative 'pieces'

class Board

  def self.deep_dup
  end

  def initialize
    @grid = Array.new(8) { Array.new(8) {false}}
  end

  def [](pos)
    #y axis has positive heading down
    row, column = pos
    @grid[row][column]
  end

  def []=(pos, piece)
    row, column = pos
    @grid[row][column] = piece
  end

  def on_board?(pos)
    pos.all? { |x| x.between?(0, 7)}
  end

  def occupied?(pos)
    self[pos] != false
  end

  def piece_at(pos)
    self[pos]
  end

  def sliding_moves_helper(pos, offset, color)
    new_pos = [pos[0]+offset[0], pos[1]+offset[1]]
    if !on_board?(new_pos)
      return []
    elsif !occupied?(new_pos)
      return [new_pos] + sliding_moves_helper(new_pos, offset, color)
    elsif self[new_pos].color != color
      return [new_pos]
    else
      return []
    end
  end

  def stepping_moves_helper(pos, offset, color)
    new_pos = [pos[0]+offset[0], pos[1]+offset[1]]
    if !on_board?(new_pos)
      return []
    elsif !occupied?(new_pos)
      return [new_pos]
    elsif self[new_pos].color != color
      return [new_pos]
    else
      return []
    end
  end

  def pawn_moves_helper(pos, direction, color, moved)
    results = []
    new_pos = [pos[0] + direction, pos[1]]
    results << new_pos if on_board?(new_pos) && !occupied?(new_pos)

    if !moved && results.include?(new_pos)
      next_pos = new_pos.dup
      next_pos[0] += direction
      results << next_pos if on_board?(next_pos) && !occupied?(next_pos)
    end

    diags = [[new_pos[0], pos[1] + 1], [new_pos[0], pos[1] - 1]]
    diags.each do |position|
      if on_board?(position) && occupied?(position) && self[position].color != color
        results << position
      end
    end


    results
  end

  def move(start_pos, end_pos)
    valid_moves = self[start_pos].possible_moves
    if valid_moves.include?(end_pos)
      self[end_pos] = self[start_pos]
      self[end_pos].moved = true
      self[start_pos] = false
      self[end_pos].pos = end_pos
    else
      raise
    end
  end

  def checkmate?
  end

  def in_check?(color)
    enemy_pieces = []
    (0..7).each do |i|
      (0..7).each do |j|
        pos = [i,j]
        if occupied?(pos) && self[pos].color != color
          enemy_pieces << self[pos]
        end
      end
    end


    total_possible_moves = []
    enemy_pieces.each do |enemy_piece|
      next if enemy_piece == nil
      total_possible_moves += enemy_piece.possible_moves
    end


    total_possible_moves.each do |move|
      if self[move].class == King
        return true
      end
    end

    false
  end

  def render
    colorize_options = {}
    print "  "
    (0..7).each { |i| print "#{i} "}
    puts
    @grid.each.with_index do |row, i|
      print i
      row.each.with_index do |el, j|
        if (i+j).odd?
          colorize_options[:background] = :black
        else
          colorize_options[:background] = :white
        end
        if el == false
          print "  ".colorize(colorize_options)
        else
          if el.color == :white
            colorize_options[:color] = :red
          else
            colorize_options[:color] = :blue
          end
          print "#{el.symbol} ".colorize(colorize_options)
        end
      end
      print "\n"
    end
    puts
    #colorize gem
    #unicode for chess pieces
  end


  #debugging method
  def delete_at(pos)
    self[pos] = false
  end

end

if __FILE__ == $PROGRAM_NAME
  # board = Board.new
  # board.render
  # pos = [0, 0]
  # p board.occupied?(pos)
  # p board[pos]
  # board[pos] = 1
  # p board[pos]
  # p board.occupied?(pos)
end
