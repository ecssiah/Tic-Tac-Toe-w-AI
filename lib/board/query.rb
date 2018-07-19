module Board

module Query
  @@cells

  def self.cells=(cells)
    @@cells = cells 
  end

  def position(input, cells=@@cells)
    cells[input.to_i - 1]
  end

  def valid_move?(input, cells=@@cells)
    pos = input.to_i - 1
    pos.between?(0, 8) && !taken?(input, cells)
  end

  def available_moves(cells=@@cells)
    moves = cells.collect.with_index { |cell, i| i if cell == " " }
    moves.compact
  end

  def taken?(input, cells=@@cells)
    position(input, cells) == "X" || position(input, cells) == "O"
  end

  def full?(cells=@@cells)
    cells.none? { |cell| cell == ' ' }
  end

  def turn_count(cells=@@cells)
    cells.count { |cell| cell != ' ' }
  end

  def winner(cells=@@cells)
    win_combo = won?(cells)
    win_combo ? cells[win_combo[0]] : nil
  end

  def won?(cells=@@cells)
    Game::WIN_COMBINATIONS.find do |combo|
      streak = cells[combo[0]] + cells[combo[1]] + cells[combo[2]]
      streak == "XXX" || streak == "OOO"
    end
  end

  def draw?(cells=@@cells)
    !won?(cells) && full?(cells)
  end

  def over?(cells=@@cells)
    draw?(cells) || won?(cells)
  end
end

end
