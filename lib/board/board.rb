module Board

Corners = [0, 2, 6, 8]

class Board
  include Query

  attr_accessor :cells

  def initialize
    @cells = Array.new(9, " ")
  end

  def update(input, player)
    position = input.to_i - 1
    self.cells[position] = player.token
    Query.cells = self.cells
  end

  def reset!
    self.cells = Array.new(9, " ")
    Query.cells = self.cells
  end

  def display
    board_display = <<~STRING

       #{@cells[0]} | #{@cells[1]} | #{@cells[2]}
      -----------
       #{@cells[3]} | #{@cells[4]} | #{@cells[5]}
      -----------
       #{@cells[6]} | #{@cells[7]} | #{@cells[8]}
 
    STRING

    puts board_display
  end
end

end
