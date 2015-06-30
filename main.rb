# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

require_relative('game')
require_relative('player')
require_relative('diceset')
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