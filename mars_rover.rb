require "test/unit/assertions"
include Test::Unit::Assertions

class Rectangle

  attr_reader :x_min
  attr_reader :y_min
  attr_reader :x_max
  attr_reader :y_max

  def initialize(x_min,y_min,x_max,y_max)
    @x_min = x_min
    @y_min = y_min
    @x_max = x_max
    @y_max = y_max
  end
end

class Rover

  attr_reader :x
  attr_reader :y
  attr_reader :direction

  def initialize(x,y,direction)
    #Check if the input is in proper format
    assert_equal true , x.is_a?(Integer)
    assert_equal true , y.is_a?(Integer)
    raise InvalidInputError if direction[/^[EWNS]$/]!=direction
    
    @cardinal_directions = ['W','N','E','S']
    @x = x
    @y = y
    @direction = direction
    @direction_index = @cardinal_directions.index(direction) 
  end

  def command(s,rectangle)
    raise InvalidInputError if s[/^[LRM]*$/]!=s
    for i in 0...s.size
      if s[i]=='L' or s[i]=='R'
	change_direction(s[i])
      elsif s[i]=='M'
        move(rectangle)
      ## Debugging
      # else
      #   puts "invalid input char detected!!"
      end 
    end	
  end

  def move(rectangle)
    move_hash = {W: [-1,0],  E: [1,0],  N: [0,1], S: [0,-1]} 
    move_by = move_hash[@direction.to_sym]
    if ( (@x + move_by[0] >= rectangle.x_min) and (@x + move_by[0] <= rectangle.x_max) and (@y+move_by[1] >=rectangle.y_min) and (@y + move_by[1]<=rectangle.y_max) )
       @x += move_by[0]
       @y += move_by[1]
    end
    #puts "Rover moved to #{x},#{y}"
  end

  def change_direction(x)
    if x=='L'
        sign = - 1
    elsif x == 'R'
        sign = 1
    end
    @direction_index = (@direction_index + sign )%4
    @direction = @cardinal_directions[@direction_index]  
    #puts "Direction changed to #{@direction}"
 end
end

if __FILE__ == $0
   input = gets.chomp
   raise InvalidInputError if input[/^(\d\s\d)$/] != input
   x_max,y_max = input.split(' ')
   raise InvalidInputError if x_max[/^\d*$/]!=x_max and y_max[/^\d*$/]!=y_max
   x_max = x_max.to_i
   y_max = y_max.to_i
   #raise InvalidInputError if (x.is_a?(Integer) and y.is_a?(Integer))
   rect = Rectangle.new(0,0,x_max,y_max)
   input = gets.chomp
   while input!=""
     raise InvalidInputError if input[/^(\d\s\d\s\w)$/]!=input
     x,y,direction = input.split(' ')
     raise InvalidInputError if x[/^\d*$/]!=x and y[/^\d*$/]!=y and direction[/^\w$/]!=direction
     x = x.to_i
     y = y.to_i
     rover = Rover.new(x,y,direction)
     command_str = gets.chomp
     rover.command(command_str,rect)
     puts "#{rover.x} #{rover.y} #{rover.direction}"  
     input = gets.chomp
   end
end
