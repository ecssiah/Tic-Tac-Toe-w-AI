class Game
  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
    #horizontal
    [0,1,2],
    [3,4,5],
    [6,7,8],
    #vertical
    [0,3,6],
    [1,4,7],
    [2,5,8],
    #diagonal
    [0,4,8],
    [2,4,6]
  ]

  def initialize
    @board = Board.new
  end

  def start
    board.reset!
    greeting
    game_mode
  end

  def game_mode
    print "Please input the gamemode you want by number (1-5): "
    input = gets.strip

    case input
    when "1"
      start_with_player_amount(1)
    when "2"
      start_with_player_amount(2)
    when "3"
      start_with_player_amount(0)
    when "4"
      start_with_player_amount("wargames")
    when "5"
      start_with_player_amount("aiwars")
    end
  end

  def start_with_player_amount(amount)
    case amount
    when 0
      @player_1 = Players::Computer.new(self, "X")
      @player_2 = Players::Computer.new(self, "O")
    when 1
      @player_1 = Players::Human.new("X")
      @player_2 = Players::Computer.new(self, "O")
    when 2
      @player_1 = Players::Human.new("X")
      @player_2 = Players::Human.new("O")
    when "wargames" 
      times_tied = 0

      100.times do
        @player_1 = Players::Computer.new(self, "X")
        @player_2 = Players::Computer.new(self, "O")

        board.reset!
        play

        if draw?
          times_tied += 1
        end
      end

      puts "
██╗    ██╗██╗███╗   ██╗███╗   ██╗███████╗██████╗    ███╗   ██╗ ██████╗ ███╗   ██╗███████╗
██║    ██║██║████╗  ██║████╗  ██║██╔════╝██╔══██╗██╗████╗  ██║██╔═══██╗████╗  ██║██╔════╝
██║ █╗ ██║██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝╚═╝██╔██╗ ██║██║   ██║██╔██╗ ██║█████╗
██║███╗██║██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗██╗██║╚██╗██║██║   ██║██║╚██╗██║██╔══╝
╚███╔███╔╝██║██║ ╚████║██║ ╚████║███████╗██║  ██║╚═╝██║ ╚████║╚██████╔╝██║ ╚████║███████╗
 ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝   ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
      "
      puts "I just played 100 games and won #{times_tied - 100}. A strange game.\nThe only winning move is not to play."
      return
    when "aiwars"
      @player_1 = Players::Computer.new(self, "X", "mm")
      @player_2 = Players::Computer.new(self, "O", "cd")

      cd_score = 0
      mm_score = 0

      100.times do 
        board.reset!
        play

        winner == "X" ? cd_score + 1 : mm_score + 1
      end

      puts
      puts "  Coffee-Dust           Minimax   "
      puts " =============       ============= "
      puts " |     #{cd_score}     |  to   |     #{mm_score}     | "
      puts " =============       ============= "
      puts

      return 
    end

    play
  end

  def play
    turn while !over?

    if won?
      board.display
      puts "Winner is #{winner}!"
    elsif draw?
      board.display
      puts "Cat's game!"
    end
  end

  def current_player
    value = @board.turn_count
    value.even? ? @player_1 : @player_2
  end

  def turn
    @board.display
    puts "Please enter 1-9:"
    move = current_player.move
    if @board.valid_move?(move)
      @board.update(move, current_player)
    else
      puts("Invalid input.")
      turn
    end
  end

  def winner
    won = won?
    return nil if won == false

    if won.all? {|cell| @board.cells[cell] == "X" }
      "X"
    elsif won.all? {|cell| @board.cells[cell] == "O" }
      "O"
    end
  end

  def won?
    WIN_COMBINATIONS.each do |cell_group|
      board_pos = [
        @board.cells[cell_group[0]], 
        @board.cells[cell_group[1]], 
        @board.cells[cell_group[2]]
      ]

      if board_pos.all? { |cell| cell == "X" } || board_pos.all? { |cell| cell == "O" }
        return cell_group
      end
    end

    false
  end

  def draw?
    !won? && @board.full?
  end

  def over?
    draw? || won?
  end

  def pry
    binding.pry
  end

end#endof class


def greeting
  puts '
╔═╗╦  ╔═╗╦ ╦  ╔╦╗╦╔═╗  ╔╦╗╔═╗╔═╗  ╔╦╗╔═╗╔═╗
╠═╝║  ╠═╣╚╦╝   ║ ║║     ║ ╠═╣║     ║ ║ ║║╣
╩  ╩═╝╩ ╩ ╩    ╩ ╩╚═╝   ╩ ╩ ╩╚═╝   ╩ ╚═╝╚═╝
  '
  puts '
┌─┐┌─┐┬  ┌─┐┌─┐┌┬┐  ┌─┐┌─┐┌┬┐┌─┐  ┌┬┐┌─┐┌┬┐┌─┐
└─┐├┤ │  ├┤ │   │   │ ┬├─┤│││├┤   ││││ │ ││├┤
└─┘└─┘┴─┘└─┘└─┘ ┴   └─┘┴ ┴┴ ┴└─┘  ┴ ┴└─┘─┴┘└─┘
  '
  puts '
     ┌─┐┌┐┌┌─┐  ┌─┐┬  ┌─┐┬ ┬┌─┐┬─┐
───  │ ││││├┤   ├─┘│  ├─┤└┬┘├┤ ├┬┘
     └─┘┘└┘└─┘  ┴  ┴─┘┴ ┴ ┴ └─┘┴└─
     ┌┬┐┬ ┬┌─┐  ┌─┐┬  ┌─┐┬ ┬┌─┐┬─┐
───   │ ││││ │  ├─┘│  ├─┤└┬┘├┤ ├┬┘
      ┴ └┴┘└─┘  ┴  ┴─┘┴ ┴ ┴ └─┘┴└─
     ┌─┐┬  ┬  ┬  ┌─┐┬
───  ├─┤│  └┐┌┘  ├─┤│
     ┴ ┴┴   └┘   ┴ ┴┴
     ┬ ┬┌─┐┬─┐┌─┐┌─┐┌┬┐┌─┐┌─┐
───  │││├─┤├┬┘│ ┬├─┤│││├┤ └─┐
     └┴┘┴ ┴┴└─└─┘┴ ┴┴ ┴└─┘└─┘
     ┌─┐┬ ┬ ┬┌─┐┬─┐┌─┐
───  ├─┤│ │││├─┤├┬┘└─┐
     ┴ ┴┴ └┴┘┴ ┴┴└─└─┘

  '
end
