module Players

class Computer < BasePlayer
  attr_reader :ai

  def initialize(game, token, ai_type=AI::CD::Identifier)
    super(token)

    if ai_type == AI::CD::Identifier 
      @ai = AI::CD.new(game, token)
    elsif ai_type == AI::MM::Identifier 
      @ai = AI::MM.new(game, token)
    elsif ai_type == AI::KM::Identifier 
      @ai = AI::KM.new(game, token)
    end
  end

  def move
    move = @ai.calculate_move
    puts move
    move
  end
end

end

