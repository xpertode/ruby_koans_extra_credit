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

