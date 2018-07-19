module AI

class MM < BaseAI
  include Board::Query

  Name = "Minimax"
  Identifier = "mm"

  def calculate_move
    if @game.board.turn_count == 0
      1 + rand(9)
    else 
      minimax(@game.board.cells)
      @input
    end
  end

  private

  def current_token(cells)
    turn_count(cells).even? ? @game.player1.token : @game.player2.token 
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

