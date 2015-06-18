require_relative 'mars_rover.rb'
require 'minitest/autorun'

class TestRover < MiniTest::Unit::TestCase
   def test_input_errors()
      assert_raise InvalidInputError do
        Rover.new(2,3,'A')
      end

      assert_raise InvalidInputError do
        Rover.new(2,3,'AB') 
      end
      
      assert_raise InvalidInputError do
        Rover.new(2,3,445)
      end
      
      assert_raise InvalidInputError do
        Rover.new(2,3,[4,5,6])
      end
      
      assert_raise InvalidInputError do
        Rover.new('d',3,'N')
      end
      
      assert_raise InvalidInputError do
        Rover.new('sdjk',3,'N')
      end    
      
      assert_raise InvalidInputError do
        Rover.new('d','M','N')
      end
   end
  
    def test_move_case_1
      r = Rover.new(1,2,'S')
      r.move(Rectangle.new(0,0,5,5))
      assert_equal "1 1 S",r.inspect
    end
    
    def test_move_case_2  
      r = Rover.new(0,0,'S')
      r.move(Rectangle.new(0,0,5,5))
      assert_equal "0 0 S",r.inspect
    end
    
    def test_case_1()    
      r = Rover.new(1,2,'N')
      r.command('LMLMLMLMM',Rectangle.new(0,0,5,5))
      assert_equal "1 3 N",r.inspect
    end
    
    def test_case_2()
      r = Rover.new(3,3,'E')
      r.command('MMRMMRMRRM',Rectangle.new(0,0,5,5))
      assert_equal "5 1 E",r.inspect
    end
     
    def test_case_3()
      r = Rover.new(0,0,'E')
      r.command('MMMMMMM',Rectangle.new(0,0,5,5))
      assert_equal "5 0 E",r.inspect
    end 
    
    def test_case_4()
      r = Rover.new(3,3,'E')
      r.command('RLRLRLRLRL',Rectangle.new(0,0,5,5))
      assert_equal "3 3 E",r.inspect
    end
    
    def test_case_5()
      r = Rover.new(2,5,'E')
      r.command('MMMMML',Rectangle.new(0,0,5,5))
      assert_equal "5 5 N",r.inspect
    end
        
end

class TestInputParser <  MiniTest::Unit::TestCase
      
      assert_raise InvalidInputError do
        InputParser.get_coordinates("55")
      end 
      
      assert_raise InvalidInputError do
        InputParser.get_coordinates("5 w")
      end           
      
      assert_raise InvalidInputError do
        InputParser.get_coordinates("SD w")
      end 
      
      assert_raise InvalidInputError do
        InputParser.get_coordinates("5 4 6")
      end 
      
      assert_raise InvalidInputError do
        InputParser.get_rover_location("1 3 C")
      end 
      
      assert_raise InvalidInputError do
        InputParser.get_rover_location("1 3 SDJ")
      end 
      
      assert_raise InvalidInputError do
        InputParser.get_rover_location("S2 G")
      end 
end

