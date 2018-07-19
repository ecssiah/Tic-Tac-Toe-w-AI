module AI

class CD < BaseAI
  Name = "Coffee Dust"
  Identifier = "cd"

  attr_reader :move

  def initialize(game, token)
    super(game, token)

    @info = MoveInfo.new(@game, @token)
  end

  def calculate_move
    @info.update

    @move = decision_order
    move = @move.is_a?(Array) ? @move[0].to_i : @move.to_i
    move += 1
    move.to_s
  end

  private

  def decision_order
    @info.first_move || @info.win || @info.cur_threat || find_best_moves
  end

  def prioritize_threats(combo, possible_moves)
    if @info.threats
      possible_moves << @info.threats.select { |i| combo.include?(i) }
    else
      possible_moves << combo.select { |i| @game.board.cells[i] == ' ' }
    end
  end 

  def find_best_moves
    best_moves = []
    possible_moves = []

    Game::WIN_COMBINATIONS.each do |combo|
      row = combo.collect { |i| @game.board.cells[i] }

      if row.include?(@token) && row.include?(' ')
        prioritize_threats(combo, possible_moves)
      end
    end

    if corner_available(possible_moves)
      best_moves = possible_moves.flatten.select do |i| 
        Board::Corners.include?(i) 
      end
    else
      best_moves = possible_moves
    end

    if possible_moves.empty?
      best_moves = @game.board.cells.select { |i| i == ' ' }
    end

    best_moves.flatten!
    best_moves.uniq!
    best_moves.sample
  end

  def corner_available(possible_moves)
    possible_moves.flatten.any? { |i| Board::Corners.include?(i) }
  end

end


class MoveInfo
  attr_reader :enemy, :first_move, :win, :cur_threat, :threats

  def initialize(game, token)
    @game = game
    @token = token
    @enemy = @token == "X" ? "O" : "X" 
  end

  def update
    @first_move = calc_first_move
    @win = calc_win
    @cur_threat = calc_cur_threat
    @threats = calc_possible_threats
  end

  private

  def calc_first_move
    if @game.turn_count == 0
      ["0", "0", "0", "2", "4", "4"].sample
    elsif @game.turn_count == 1
      "4" if Board::Corners.any? { |i| enemy_locations.include?(i) }
    end
  end

  def calc_win
    wins = []

    Game::WIN_COMBINATIONS.each do |combo|
      my_presence = my_locations.select { |i| combo.include?(i) }

      if my_presence.count == 2
        wins << combo.select { |i| @game.board.cells[i] == ' ' }
      end
    end

    wins.flatten.empty? ? nil : wins.flatten!
  end

  def calc_cur_threat
    threats = []

    Game::WIN_COMBINATIONS.each do |combo|
      enemy_presence = enemy_locations.select { |i| combo.include?(i) }

      if enemy_presence.count == 2
        threats << combo.select { |i| @game.board.cells[i] == ' ' }
      end
    end

    threats.flatten.empty? ? nil : threats.flatten!
  end

  def calc_possible_threats
    threats = []

    Game::WIN_COMBINATIONS.each do |combo|
      no_presence = combo.none? { |i| @game.board.cells[i] == @token }
      enemy_presence = enemy_locations.select { |i| combo.include?(i) }
       
      if no_presence && enemy_presence.count == 1
        threats << combo.select { |i| @game.board.cells[i] == ' ' }
      end
    end

    threats.flatten.empty? ? nil : threats.flatten!
  end

  def enemy_locations
    enemy_positions = @game.board.cells.collect.with_index do |cell, i| 
      i if cell == @enemy 
    end

    enemy_positions.compact
  end

  def my_locations
    my_positions = @game.board.cells.collect.with_index do |cell, i| 
      i if cell == @token 
    end

    my_positions.compact
  end
end

end

