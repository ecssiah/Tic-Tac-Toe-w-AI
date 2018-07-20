module Players

class Computer < BasePlayer
  attr_reader :ai

  def initialize(game, token, ai_type=AI::CD::Identifier)
    super(token)

    case ai_type 
    when AI::CD::Identifier
      @ai = AI::CD.new(game, token)
    when AI::MM::Identifier
      @ai = AI::MM.new(game, token)
    when AI::KM::Identifier
      @ai = AI::KM.new(game, token)
    when AI::MS::Identifier
      @ai = AI::MS.new(game, token)
    end
  end

  def move
    move = @ai.calculate_move
    puts move
    move
  end
end

end

