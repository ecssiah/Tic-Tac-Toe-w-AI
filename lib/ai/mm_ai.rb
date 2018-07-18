module MM_AI

class AI
  def initialize(game, token)
    @game = game
    @token = token
  end

  def available_moves(cells)
    moves = []

    for i in 0...cells.length
      if cells[i] == " "
        moves << i
      end
    end

    moves
  end

  def over?(cells)
    full?(cells) || won?(cells)
  end

  def current_token(cells)
    turn_count(cells).even? ? @game.player_1.token : @game.player_2.token 
  end

  def full?(cells)
    cells.none? {|cell| cell == " "}
  end

  def won?(cells)
    Game::WIN_COMBINATIONS.find do |combo|
      streak = cells[combo[0]] + cells[combo[1]] + cells[combo[2]]
      streak == "XXX" || streak == "OOO"
    end
  end

  def winner(cells)
    win_combo = won?(cells)
    win_combo ? cells[win_combo[0]] : nil
  end

  def turn_count(cells)
    cells.count { |cell| cell != " " }
  end

  def generate_state(move, cells)
    cells.map.with_index do |cell, i|
      i == move.to_i ? current_token(cells) : cell
    end
  end

  def score(cells)
    if winner(cells) == @token
      10 - turn_count(cells)
    elsif winner(cells).nil?
      0
    else
      -10 + turn_count(cells)
    end
  end

  def minimax(cells)
    return score(cells) if over?(cells)

    scores = []
    moves = []

    available_moves(cells).each do |move|
      new_cells = generate_state(move, cells)
      scores << minimax(new_cells)
      moves << move
    end

    if current_token(cells) == @token
      max_score_index = scores.each.with_index.max[1]
      @input = moves[max_score_index] + 1
      scores[max_score_index]
    else
      min_score_index = scores.each.with_index.min[1]
      @input = moves[min_score_index] + 1
      scores[min_score_index]
    end
  end

  def calculate_move
    if turn_count(@game.board.cells) == 0
      1 + rand(9)
    else 
      minimax(@game.board.cells)
      @input
    end
  end

end

end

