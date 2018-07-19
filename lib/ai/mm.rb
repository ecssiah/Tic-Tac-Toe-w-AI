module AI

class MM < BaseAI
  include Board::Query

  Name = "Minimax"
  Identifier = "mm"

  def calculate_move
    if @game.board.turn_count == 0
      Board::Corners.sample
    else 
      minimax(@game.board.cells)
      @move
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

    is_player = current_token(cells) == @token

    score_enum = scores.each.with_index
    index = is_player ? score_enum.max[1] : score_enum.min[1]

    @move = moves[index] + 1
    scores[index]
  end

end

end

