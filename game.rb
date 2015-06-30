require_relative('player')
require_relative('diceset')

require_relative('constants')
class Game
    include Constants
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
      if points >= Constants::MIN_SCORE_TO_GET_IN_FINAL_ROUND
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
