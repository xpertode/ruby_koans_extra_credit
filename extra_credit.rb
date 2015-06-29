# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.


MIN_SCORE_TO_GET_IN_THE_GAME = 300
MIN_SCORE_TO_GET_IN_FINAL_ROUND = 3000

class DiceSet
   
   def roll(size)	
	     @set = Array.new(size){rand(1..6)} 
   end
   
   def values
       @set
   end

   def self.score(dice)
     points = 0 
     if dice.size == 0
       return points
     end
     num_freq = Array.new(6){0}
 
     dice.each do |i|
       num_freq[i-1]+=1
     end 
     points+= (num_freq[0]<3) ? (num_freq[0]*100) : (((num_freq[0]-3)*100)+ 1000) #Scoring for a set of "1	
     #Scoring for set of 2,3,4,5,6
     for i in 1..5
       if num_freq[i]>=3
         points+=((i+1)*100)
         break
       end
     end 
     points+= num_freq[4]<3 ? num_freq[4]*50 : (num_freq[4]-3)*50 #50 points for a 5  
     return points      
   end   
   
   def self.non_scoring_dices(dice)
     num_scoring_dices = 0
     num_freq = Array.new(6){0}
  	  dice.each do |i|
  	    num_freq[i-1]+=1
     end     
    #Find a set of three's
    num_scoring_dices +=3 if  num_freq.select{|i| i>=3}.count > 0   ##Needs to be updated if >5 dices are used     
     #Handle the case of more than three or less than three 1's and 5's
     scoring_nums = [0,4]            #0==>1 and 4==>5
     for i in scoring_nums
       if num_freq[i]>3
           num_scoring_dices+=num_freq[i]-3
       elsif num_freq[i]<3
           num_scoring_dices+=num_freq[i]
       end
     end
     return num_scoring_dices==dice.size ? 5 : dice.size - num_scoring_dices
   end    
end


class Game

    def initialize(num_of_players)
	     raise NumberofPlayerError if num_of_players < 2
         @num_of_players = num_of_players
         @all_players = Array.new
         @current_player = 0
         @final_round = false       
         #Create players with name
         for i in 1..num_of_players
           p=Player.new("Player #{i}")
           @all_players << p
         end     
    end
    
    def play(p)
      puts "#{p.name} is going to roll in his new turn."
      points,values = p.roll_and_score  
      #Let player enter the game if he meets the min. points criteria
      p.get_in_game(points)
      unless p.is_in_game?
        points = 0
      end
      
      while points!=0 and p.continue?
        puts "#{p.name} has decided to continue his turn!!"
        #Calculate number of non scoring dices
        num_non_scoring_dices = DiceSet.non_scoring_dices(values)
        one_roll_points,values = p.roll_and_score(num_non_scoring_dices)         
        if one_roll_points == 0 
          points = 0
        else
          points+=one_roll_points #update the accumulated points
          check_for_final_round(p,points+p.get_score,'update')
        end     
      end
      p.update_score_by(points)
      check_for_final_round(p,p.get_score)
      puts "In this turn #{p.name} accumulated #{points}.Total Score: #{p.get_score}" 
      return p
    end
    
    def check_for_final_round(p,points,status='')
      if points >= MIN_SCORE_TO_GET_IN_FINAL_ROUND
        if status == 'update'
          p.update_score_by(points)
        end
        self.final_round!
        puts "Final Round.Try your best!!"
      end
    end  
    
    def play_final_round(p,highest_score)
      player_marker = p #Mark the player who initiated final round 
      winner = p
      p = self.next_turn 
  
      while p!=player_marker
        self.play(p)
        if p.get_score > highest_score
          highest_score = p.get_score
          winner = p
        end
          p = self.next_turn
      end
      return winner
    end
    
    
    def next_turn
	      @current_player = (@current_player+1)%(@num_of_players)
        return @all_players[@current_player]  
    end
     
    def current_player
      return @all_players[@current_player]
    end
    
    def score_of_all_players
      for i in @all_players
        i.inspect
      end
    end
    
    def final_round?
      @final_round
    end
    
    def final_round!
      @final_round = true
    end
    
end    



class Player
  
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
      if points < MIN_SCORE_TO_GET_IN_THE_GAME
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




############################################################################################
##
## Main Function
##
############################################################################################

if __FILE__== $0
  puts "Enter the number of players:"
  num_players = gets.chomp.to_i
  puts "Loading game..."
  
  game = Game.new(num_players)
  p = game.current_player
  highest_score = 0
  
  #Play game
  while true
    game.play(p)
    if game.final_round?
      highest_score = p.get_score
      break
    end
    p = game.next_turn
  end
  
  #Final Round
  winner = game.play_final_round(p,highest_score)
  puts "#{winner.name} has won the game,Congratulations!!"
end