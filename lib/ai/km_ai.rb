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

    false
  end

  def take_win
    Game::WIN_COMBINATIONS.each do |combo|
      combo_state = [
        @game.board.cells[combo[0]], 
        @game.board.cells[combo[1]], 
        @game.board.cells[combo[2]]
      ]

      blanks = combo_state.find_all { |cell| cell == " " }
      tokens = combo_state.find_all { |cell| cell == @token }

      if tokens.size == 2 && blanks.size == 1
        choice = combo[combo_state.find_index(" ")] + 1
        return choice.to_s
      end
    end

    false
  end

  def block_opposing
    Game::WIN_COMBINATIONS.each do |combo|
      combo_state = [
        @game.board.cells[combo[0]], 
        @game.board.cells[combo[1]], 
        @game.board.cells[combo[2]]
      ]

      blanks = combo_state.find_all { |cell| cell == " " }
      tokens = combo_state.find_all { |cell| cell == @token }

      if tokens.size == 0 && blanks.size == 1
        choice = combo[combo_state.find_index(" ")] + 1
        return choice.to_s
      end
    end

    false
  end

  def further_agenda
    Game::WIN_COMBINATIONS.each do |combo|
      combo_state = [
        @game.board.cells[combo[0]], 
        @game.board.cells[combo[1]], 
        @game.board.cells[combo[2]]
      ]

      blanks = combo_state.find_all { |cell| cell == " " }
      tokens = combo_state.find_all { |cell| cell == @token }

      if tokens.size == 1 && blanks.size >= 1
        choice = combo[combo_state.find_index(" ")] + 1
        return choice.to_s
      end
    end

    false
  end

  def pursue_strategy
    take_win || block_opposing || further_agenda
  end

  def choose_randomly
    possible_moves = (1..9).select do |cell|
      @game.board.cells[cell - 1] == " "
    end

    possible_moves[Random.rand(possible_moves.size)].to_s
  end

end

end
