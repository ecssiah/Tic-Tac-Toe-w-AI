class Game
  include Board::Query

  attr_accessor :board, :player1, :player2

  AI_List = {
    AI::MM::Name => AI::MM::Identifier,
    AI::CD::Name => AI::CD::Identifier,
    AI::KM::Name => AI::KM::Identifier
  }

  WIN_COMBINATIONS = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6]
  ]

  def initialize
    @board = Board::Board.new
    Board::Query.cells = @board.cells
  end

  def start
    greeting
    select_game_mode
  end

  def select_game_mode
    print "Please select a game mode: "

    case gets.strip
    when "1"
      execute_game(1)
    when "2"
      execute_game(2)
    when "3"
      execute_game(0)
    when "4"
      execute_ai_wars
    else
      execute_game(1)
    end
  end

  def execute_game(num_players)
    case num_players
    when 0
      @player1 = Players::Computer.new(self, "X", select_ai("X"))
      @player2 = Players::Computer.new(self, "O", select_ai("O"))
    when 1
      @player1 = Players::Human.new("X")
      @player2 = Players::Computer.new(self, "O", select_ai("O"))
    when 2
      @player1 = Players::Human.new("X")
      @player2 = Players::Human.new("O")
    end

    play
  end

  def select_ai(token)
    puts
    AI_List.each { |name, identifier| puts "#{name}: #{identifier}" }
    puts

    ai_type = nil

    until AI_List.has_value?(ai_type)
      print "Choose the AI for #{token}: "
      ai_type = gets.strip
    end

    ai_type
  end

  def execute_ai_wars
    games = 100
    scores = [0, 0]

    x_player = Players::Computer.new(self, "X", select_ai("X"))
    o_player = Players::Computer.new(self, "O", select_ai("O"))

    games.times { |game| run_game(game, x_player, o_player, scores) }

    conclusion(games, x_player, o_player, scores)
  end

  def run_game(game, x_player, o_player, scores)
    if game.even?
      @player1 = x_player
      @player2 = o_player
    else
      @player1 = o_player
      @player2 = x_player
    end

    play

    if winner == "X"
      scores[0] += 1
    elsif winner == "O"
      scores[1] += 1
    end
  end

  def conclusion(games, x_player, o_player, scores)
    ties = games - scores.reduce(:+)

    final_message = <<~STRING

      =-=-=-=-=-=-=-=-=-=-=-=-=-=

        #{games} games were played.
    
        #{x_player.ai.class::Name}: #{scores[0]}  
        #{o_player.ai.class::Name}: #{scores[1]}
        Ties: #{ties}

      =-=-=-=-=-=-=-=-=-=-=-=-=-=

    STRING
    
    puts final_message
  end

  def turn
    @board.display

    print "Choose position (1-9): "
    move = current_player.move

    if valid_move?(move)
      @board.update(move, current_player)
    else
      puts("#{move} is an invalid position.")
      turn
    end
  end

  def play
    @board.reset!

    turn while !over?
    board.display

    if won?
      puts "Winner is #{winner}!"
    elsif draw?
      puts "Tie Game!"
    end
  end

  def current_player
    turn_count.even? ? @player1 : @player2
  end

  def greeting
    message = <<~STRING
      ╔═══════════════════════════════╗
      ║ ╔╦╗╦╔═╗  ╔╦╗╔═╗╔═╗  ╔╦╗╔═╗╔═╗ ║
      ║  ║ ║║     ║ ╠═╣║     ║ ║ ║║╣  ║ 
      ║  ╩ ╩╚═╝   ╩ ╩ ╩╚═╝   ╩ ╚═╝╚═╝ ║
      ╚═══════════════════════════════╝ 

      ┌─┐┌─┐┬  ┌─┐┌─┐┌┬┐  ┌─┐┌─┐┌┬┐┌─┐  ┌┬┐┌─┐┌┬┐┌─┐
      └─┐├┤ │  ├┤ │   │   │ ┬├─┤│││├┤   ││││ │ ││├┤
      └─┘└─┘┴─┘└─┘└─┘ ┴   └─┘┴ ┴┴ ┴└─┘  ┴ ┴└─┘─┴┘└─┘

       ┬    ┌─┐┌┐┌┌─┐  ┌─┐┬  ┌─┐┬ ┬┌─┐┬─┐
       │  - │ ││││├┤   ├─┘│  ├─┤└┬┘├┤ ├┬┘
       ┴    └─┘┘└┘└─┘  ┴  ┴─┘┴ ┴ ┴ └─┘┴└─
      ┌─┐   ┌┬┐┬ ┬┌─┐  ┌─┐┬  ┌─┐┬ ┬┌─┐┬─┐
      ┌─┘ -  │ ││││ │  ├─┘│  ├─┤└┬┘├┤ ├┬┘
      └─┘    ┴ └┴┘└─┘  ┴  ┴─┘┴ ┴ ┴ └─┘┴└─
      ┌─┐   ┌─┐┬  ┬  ┬  ┌─┐┬
       ─┤ - ├─┤│  └┐┌┘  ├─┤│
      └─┘   ┴ ┴┴   └┘   ┴ ┴┴
      ┬ ┬   ┌─┐┬  ┬ ┬┌─┐┬─┐┌─┐
      └─┤ - ├─┤│  │││├─┤├┬┘└─┐
        ┴   ┴ ┴┴  └┴┘┴ ┴┴└─└─┘

    STRING

    puts message
  end
end

