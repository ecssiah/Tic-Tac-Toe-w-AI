class Board
  attr_accessor :cells

  def initialize
    @cells = Array.new(9, " ")
  end

  def update(input, player)
    position = input.to_i - 1
    self.cells[position] = player.token
  end

  def reset!
    self.cells = Array.new(9, " ")
  end

  def position(input)
    self.cells[input.to_i - 1]
  end

  def valid_move?(input)
    pos = input.to_i - 1
    pos.between?(0, 8) && !taken?(input)
  end

  def taken?(input)
    self.position(input) == "X" || self.position(input) == "O"
  end

  def full?
    self.cells.none? {|cell| cell == " " || cell == ""}
  end

  def turn_count
    @cells.count { |cell| cell != " " }
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

