module ENVIRONMENTS
  module DEV

    def start_CLI
      puts "Input a method name on the main scope or a command."
      input = gets.strip
      while input != "exit"
        case input
        when "pry"
          start_pry
        when "reload"
          reload!
        when "list"
          list
        when "wargames"
          100.times do
            g = Game.new
            g.start_with_player_amount(0)
          end

        else
          begin
            g = Game.new
            g.send("#{input}")
          rescue
            Quorra.speak("Not a valid method, Why are you so stupid?")
          end
        end
        input = gets.strip
      end
    end#endof method

    def start_pry
      binding.pry
      puts "Welcome back! Now input a command fewl!"
      Quorra.say("Welcome back, now input a command fool")
    end

    def reload!
      load_all "./config" if Dir.exists?("./config")
      load_all "./app" if Dir.exists?("./app")
      load_all "./lib" if Dir.exists?("./lib")
      load_all "./*.rb" if Dir.entries(".").include?(/\.rb/)
    end

    def self.included(base)
      ENV["APP_ENV"] = "DEV"
      Bundler.require(:dev)
      puts '
         +--------------+
         |.------------.|
         ||>_          ||
         ||            ||
         ||            ||
         ||            ||
         |+------------+|
         +-..--------..-+
         .--------------.
         / /============\ \\
        / /==============\ \\
       /____________________\\
       \____________________/ '
      puts '
  ╔╦╗┌─┐┬  ┬┌─┐┬  ┌─┐┌─┐┌┬┐┌─┐┌┐┌┌┬┐
   ║║├┤ └┐┌┘├┤ │  │ │├─┘│││├┤ │││ │
  ═╩╝└─┘ └┘ └─┘┴─┘└─┘┴  ┴ ┴└─┘┘└┘ ┴
  ╔═╗┌┐┌┬  ┬┬┬─┐┌─┐┌┐┌┌┬┐┌─┐┌┐┌┌┬┐
  ║╣ │││└┐┌┘│├┬┘│ │││││││├┤ │││ │
  ╚═╝┘└┘ └┘ ┴┴└─└─┘┘└┘┴ ┴└─┘┘└┘ ┴
      '
    end

  end#endof dev

  module DEFAULT

    def self.included(base)
      ENV["APP_ENV"] = "DEFAULT"
    end

  end


end#endof module
