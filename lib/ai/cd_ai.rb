module CD_AI

class MoveInfo
  attr_reader :game, :token, :enemy, :curr_threat, :win, :threats, :move

  def initialize(game, token)
    @game = game
    @token = token

    set_tokens

    @win = calc_win
    @curr_threat = calc_curr_threat
    @threats = calc_possible_threats
  end

  def set_tokens
    if @token == "X"
      @enemy = "O"
    elsif @token == "O"
      @enemy = "X"
    end
  end

  def calc_win
    wins = []

    Game::WIN_COMBINATIONS.each do |combo|
      my_presence = my_locations.select { |i| combo.include?(i) }

      if my_presence.count >= 2
        wins << combo.select{ |i| @game.board.cells[i] == " " }
      end
    end

    wins.flatten.empty? ? nil : wins.flatten!
  end

  def calc_curr_threat
    threats = []

    Game::WIN_COMBINATIONS.each do |combo|
      enemy_presence = enemy_locations.select { |i| combo.include?(i) }

      if enemy_presence.count >= 2
        threats << combo.select { |i| @game.board.cells[i] == " " }
      end
    end

    threats.flatten.empty? ? nil : threats.flatten!
  end

  def calc_possible_threats
    threats = []

    Game::WIN_COMBINATIONS.each do |combo|
      no_presence = combo.all? { |i| @game.board.cells[i] != @token }
      enemy_presence = enemy_locations.select { |i| combo.include?(i) }
       
      if no_presence && enemy_presence.count >= 1
        threats << combo.select { |i| @game.board.cells[i] == " " }
      end
    end

    threats.flatten.empty? ? nil : threats.flatten!
  end

  def enemy_locations
    enemy_cells = @game.board.cells.collect.with_index do |cell, i| 
      i if cell == @enemy 
    end

    enemy_cells.compact
  end

  def my_locations
    my_cells = @game.board.cells.collect.with_index do |cell, i| 
      i if cell == self.token 
    end

    my_cells.compact
  end

end#endof class


class AI
  attr_reader :move_status, :move

  def initialize(game, token)
    @game = game
    @token = token
  end

  def calculate_move
    @info = MoveInfo.new(@game, @token)

    @move = decision_order
    @move.is_a?(Array) ? move = @move[0].to_i : move = @move.to_i
    move += 1
    move.to_s
  end

  def decision_order
    if (m = decide_first_move)
      m
    elsif @info.win
      @info.win
    elsif @info.curr_threat
      @info.curr_threat
    else
      find_best_move
    end
  end

  # Chooses the cells that are threats if available.
  def prioritize_threats(combo, possible_moves)
    if @info.threats
      possible_moves << @info.threats.select { |i| combo.include?(i) }
    else
      possible_moves << combo.select { |i| @game.board.cells[i]==" "}
    end
  end 

  def find_best_move
    best_move = []
    possible_moves = []

    Game::WIN_COMBINATIONS.each do |combo|
      row_contents = combo.collect { |i| @game.board.cells[i] }

      # Choose combo with player token and empty spaces.
      combo_has_token = row_contents.include?(@info.token)
      combo_has_empty = row_contents.any? { |i| i == ' ' }

      if combo_has_token && combo_has_empty
        prioritize_threats(combo, possible_moves)
      end
    end

    # Chooses corners if available.
    if possible_moves.flatten.any? { |i| [0,2,6,8].include?(i) }
      best_move = possible_moves.flatten.select { |i| [0,2,6,8].include?(i) }
    else
      best_move = possible_moves
    end

    # If all else has failed. Chooses a empty space.
    if possible_moves.empty?
      best_move = @game.board.cells.select { |i| i == " " }
    end

    best_move.flatten!
    best_move.uniq!
    best_move.sample
  end

  def decide_first_move
    if first_move_on_board?
      ["0", "0", "0", "2", "4", "4"].sample
    elsif @info.enemy_locations.count == 1 && @info.my_locations.count == 0
      "4" if [0,2,6,8].any? { |i| @info.enemy_locations.include?(i) }
    end
  end

  def first_move_on_board?
    @game.board.cells.all? { |cell| cell == " " }
  end

end#endof class

end#endof CD_AI
