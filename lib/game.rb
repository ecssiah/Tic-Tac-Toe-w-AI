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
    self.board.reset!
    greeting
    self.game_mode
  end

  def game_mode
    puts "Please input the gamemode you want by number: (1-3)"
    input = gets.strip
    case input
    when "1"
      self.start_with_player_amount(0)
    when "2"
      self.start_with_player_amount(1)
    when "3"
      self.start_with_player_amount(2)
    when "wargames"
      self.start_with_player_amount("wargames")
    end
  end

  def start_with_player_amount(amount)
    case amount
    when 0
      @player_1 = Players::Computer.new("X")
      @player_2 = Players::Computer.new("O")
    when 1
      @player_1 = Players::Human.new("X")
      @player_2 = Players::Computer.new("O")
    when 2
      @player_1 = Players::Human.new("X")
      @player_2 = Players::Human.new("O")
    when "wargames"
      times_tied = 0
      100.times do
        @player_1 = Players::Computer.new("X")
        @player_2 = Players::Computer.new("O")
        self.board.reset!
        self.play
        if self.draw?
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
    end
    self.play
  end

  def play
    while !self.over?
      turn
    end
    if self.won?
      self.board.display
      Quorra.speak("Winner is #{self.winner}, loser is stupid!")
      `afplay ~/Music/RandomSounds/roast.mp3`
    elsif self.draw?
      self.board.display
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
    move = current_player.move(self)
    if @board.valid_move?(move)
      @board.update(move, current_player)
    else
      puts("Invalid input.")
      self.turn
    end
  end

  def winner
    won = self.won?
    return nil if won == false
    if won.all? {|cell| @board.cells[cell] == "X" }
      "X"
    elsif won.all? {|cell| @board.cells[cell] == "O" }
      "O"
    end
  end

  def won?
    WIN_COMBINATIONS.each do |cell_group|
      board_pos = [@board.cells[cell_group[0]], @board.cells[cell_group[1]], @board.cells[cell_group[2]]]

      if board_pos.all? { |cell| cell == "X" } || board_pos.all? { |cell| cell == "O" }
        return cell_group
      end
    end
    return false
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
     ┌─┐┬  ┬  ┬  ┌─┐┬
───  ├─┤│  └┐┌┘  ├─┤│
     ┴ ┴┴   └┘   ┴ ┴┴
     ┌─┐┌┐┌┌─┐  ┌─┐┬  ┌─┐┬ ┬┌─┐┬─┐
───  │ ││││├┤   ├─┘│  ├─┤└┬┘├┤ ├┬┘
     └─┘┘└┘└─┘  ┴  ┴─┘┴ ┴ ┴ └─┘┴└─
     ┌┬┐┬ ┬┌─┐  ┌─┐┬  ┌─┐┬ ┬┌─┐┬─┐
───   │ ││││ │  ├─┘│  ├─┤└┬┘├┤ ├┬┘
      ┴ └┴┘└─┘  ┴  ┴─┘┴ ┴ ┴ └─┘┴└─
  '
end
