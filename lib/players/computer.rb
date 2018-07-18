module Players

class Computer < Player
  def initialize(game, token, ai="cd")
    super(token)

    if ai == "cd"
      @ai = CD_AI::AI.new(game, token)
    elsif ai == "mm"
      @ai = MM_AI::AI.new(game, token)
    end
  end

  def move
    @ai.calculate_move
  end
end

end#endof Module
