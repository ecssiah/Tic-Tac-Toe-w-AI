module AI

class KM < BaseAI
  Name = "Karyme"
  Identifier = "km"

  def calculate_move
    opening || pursue_strategy || choose_randomly
  end

  private

  def opening
    center = 5
    corners = [1,3,7,9]

    if @game.board.turn_count == 0
      return corners.sample
    elsif @game.board.turn_count == 1
      if corners.any? { |cell| @game.board.taken?(cell) }
        return center
      else
        return corners.sample
      end
    end

    nil
  end

  def pursue_strategy
    take_win || block_opposing || further_agenda
  end

  def take_win
    scan_board(2, 1, :==)
  end

  def block_opposing
    scan_board(0, 1, :==)
  end

  def further_agenda
    scan_board(1, 1, :>=)
  end

  def scan_board(token_target, blank_target, blank_operator)
    Game::WIN_COMBINATIONS.each do |combo|
      combo_state = [
        @game.board.cells[combo[0]], 
        @game.board.cells[combo[1]], 
        @game.board.cells[combo[2]]
      ]

      blanks = combo_state.find_all { |cell| cell == " " }
      tokens = combo_state.find_all { |cell| cell == @token }

      token_criteria = tokens.size == token_target  
      blank_criteria = blanks.size.send(blank_operator, blank_target) 

      if token_criteria && blank_criteria 
        choice = combo[combo_state.find_index(" ")] + 1
        return choice.to_s
      end
    end

    nil
  end

  def choose_randomly
    possible_moves = (1..9).select do |cell|
      @game.board.cells[cell - 1] == " "
    end

    possible_moves[rand(possible_moves.size)].to_s
  end

end

end
