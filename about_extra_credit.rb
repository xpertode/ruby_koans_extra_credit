# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

#require_relative 'game_class'
#require_relative 'player_class'
#require_relative 'diceset_class'

class DiceSet
   def roll(size)	
	@set = Array.new(size){rand(1..6)} 
   end
   def values
       @set
   end
end


class Game

    #def self.all
     #   ObjectSpace.each_object(Player){|player| @all_players << player}
    #    #@all_players
    #end
    
    
    def initialize(num_of_players)
	     raise NumberofPlayerError if num_of_players<2
         @num_of_players = num_of_players
         @all_players=Array.new
         @current_player = 0
         @final_round =false
         #create players with name
         for i in 1..num_of_players
           p=Player.new("Player #{i}")
           puts p.inspect
           @all_players << p
         end
         #ObjectSpace.each_object(Player){|player| @all_players << player}       
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
    #attr_reader :score
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
      puts "y/n?"
      response = gets.chomp
      if response=='y'
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

    def non_scoring_dices(dice)
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


    def calculate_score(dice)
	    return score(dice)
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

  def score(dice)
 	  points = 0 
 	  if dice.size == 0
	     return points
 	  end

	  num_freq = Array.new(6){0}
 
    dice.each do |i|
 		  num_freq[i-1]+=1
 	  end 
 
    #Scoring for a set of "1	
 	  points+= (num_freq[0]<3) ? (num_freq[0]*100) : (((num_freq[0]-3)*100)+ 1000)
 
 	  #scoring for set of 2,3,4,5,6
	  for i in 1..5
   	  if num_freq[i]>=3
	      points+=((i+1)*100)
      	break
   	  end
	  end  

	  #50 points for a 5
    points+= num_freq[4]<3 ? num_freq[4]*50 : (num_freq[4]-3)*50 
	  return points      
  end    

def play(p,game)
  puts "#{p.name} is going to roll in first turn"
  values = p.roll
  print "#{values}\n"
  points =  p.calculate_score(values)
  print "#{p.name} got #{points}\n"
  #Check if player is in the game or not.
  if points < 300
    unless p.is_in_game?
      #p=Game.next_turn  ##return
      puts "Alas! I lost :("
      #next
      return points
    end
  else
    unless p.is_in_game?
      p.is_in_game!
      puts "Hurray,I am in the game :)"
    end
  end
  
  while p.continue? and points!=0
    puts "I am gonna continue baby!!"
    num_dices = p.non_scoring_dices(values)
    
    values = p.roll(num_dices)
    
    print "I got #{values} "
    
    one_roll_points = p.calculate_score(values)
    
    print " making score of :#{one_roll_points}\n"
    
    if one_roll_points==0 
      points=0
      return points
    else
      points+=one_roll_points
      puts "Final Round? #{p.get_score} and #{points}"
      if (p.get_score + points) >= 3000
        puts "Yeah,final round.Beat me if you can!"
        p.update_score_by(points)
        game.final_round!
        print "In this turn #{p.name} scored #{p.get_score}\n" 
        return points
      end  
      
    end  
    puts "I'm rocking,#{points} accumulated"  
  end
    
  p.update_score_by(points)
  
  #Check for final round
  if p.get_score >= 3000
    puts "Hurray,final round!! :)"
    game.final_round!
  end
  
  print "In this turn #{p.name} scored #{p.get_score}" 
  return p
end

if __FILE__== $0
  NUM_PLAYERS = 4
  puts "Loading game..."
  game = Game.new(NUM_PLAYERS)
  p = game.current_player
  p.inspect
  highest_score=0
  while true
    play(p,game)
    if game.final_round?
      highest_score = p.get_score
      break
    end
    p = game.next_turn
    #print game.score_of_all_players
    #p = Game.current_player
  end
  
  
  player_marker = p
  winner = p
  p=game.next_turn
  while p!=player_marker
    play(p,game)
    if p.get_score > highest_score
      highest_score = p.get_score
      winner = p
    end
      p=game.next_turn
  end
  puts "Hurray,#{winner.name} has won the game!"
end