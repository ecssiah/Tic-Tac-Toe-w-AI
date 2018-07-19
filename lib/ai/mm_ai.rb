module AI

class MM
  Name = "Minimax"
  Identifier = "mm"

  def initialize(game, token)
    @game = game
    @token = token
  end

  def calculate_move
    if @game.board.turn_count == 0
      1 + rand(9)
    else 
      minimax(@game.board.cells)
      @input
    end
  end

  def name
    Name
  end

  private

  def available_moves(cells)
    moves = cells.collect.with_index { |cell, i| i if cell == " " }
    moves.compact
  end

  def over?(cells)
    full?(cells) || won?(cells)
  end

  def current_token(cells)
    turn_count(cells).even? ? @game.player1.token : @game.player2.token 
  end

  def full?(cells)
    cells.none? { |cell| cell == " " }
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

    moves = []
    scores = []

    available_moves(cells).each do |move|
      new_cells = generate_state(move, cells)
      scores << minimax(new_cells)
      moves << move
    end

    score_enum = scores.each.with_index
    is_player = current_token(cells) == @token
    index = is_player ? score_enum.max[1] : score_enum.min[1]

    @input = moves[index] + 1
    scores[index]
  end

end

end

