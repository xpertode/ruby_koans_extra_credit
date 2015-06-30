require_relative('diceset')
require_relative('game')
require_relative('constants')
class Player
    include Constants
    attr_reader :name
    @is_in_game = false

    def initialize(name)
      @score=0
	    @name = name
    end

    def roll(size=5)
      dice = DiceSet.new
      dice.roll(size)
      return dice.values
    end
    
    def continue?
      puts "Do you wanna continue:y/n?"
      response = gets.chomp
      if response == 'y'
        true
      elsif response=='n'
	       false
      end
    end

    def is_in_game?
	    @is_in_game
    end

    def is_in_game!
	    @is_in_game = true
    end

    def get_in_game(points)
      if points < Constants::MIN_SCORE_TO_GET_IN_THE_GAME
        unless self.is_in_game?
          puts "#{self.name} didn't score much to enter the game."
        end
      else
        unless self.is_in_game?
          self.is_in_game!
          puts "#{self.name} has entered the game.Good luck!!"
        end
      end
    end
    
    def roll_and_score(num=5)
      values = self.roll(num)
      puts "The values on dices are: #{values} " 
      one_roll_points = self.calculate_score(values)
      puts "#{self.name} got #{one_roll_points} from this roll"
      return one_roll_points,values
    end
    
    
    def calculate_score(dice)
	    return DiceSet.score(dice)
    end
     
    def update_score_by(points)
    	@score += points
    end
    
    def make_score_zero
	    @score = 0
    end
    
    def get_score
      @score
    end
    
    def inspect
	    return "Score of #{@name} is #{@score}"
    end
end
