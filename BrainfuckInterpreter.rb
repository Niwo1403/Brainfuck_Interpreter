require "io/console"

class BrainfuckInterpreter
  ##
  # Example:
  #
  # printing "asdf":
  # ++++++>>+>+>+>+<<<<<[>++++++++[>++>++>++>++<<<<-]<-]>>.<++++++[>>+++<<-]>>.>+++.>+++++.
  #
  # Hello World program (src: https://de.wikipedia.org/wiki/Brainfuck#Hello_World!)
  # ++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.+++.

  def initialize
    # Initialize a BrainfuckInterpreter object by creating the array for the code, the pointer and the needed variables.
    @arr = [0]
    @pointer = 0
    @loop = ""
    @bracket_open = 0
  end

  def execute code
    # Execudes the Brainfuckcode passed in +code+ as argument.
    # Parms:
    # +code+:: Brainfuckcode to execute
    code.split("").each do |c|
      # check if c is a valid char:
      if [",", ".", "+", "-", "[", "]", "<", ">"].include? c
        # find matching method:
        if c == ","
          c = ".comma"
        elsif c == "."
          c = ".dot"
        elsif c == "["
          c = ".brack_open"
        elsif c == "]"
          c = ".brack_close"
        else
          c = " " + c
        end
        eval "self#{c} nil"
      end
    end
  end

  def < other
    # Decrease the pointer by one.
    # Parms:
    # +other+:: isn't used, can be nil
    if @bracket_open == 0
      @pointer -= 1
      if @pointer < 0 # check for underflow
        # add new element to the begin of the array
        @arr = [0] + @arr
        @pointer = 0
      end
    else
      # currently in a loop, so append to @loop
      @loop += "<"
    end
  end

  def > other
    # Increase the pointer by one.
    # Parms:
    # +other+:: isn't used, can be nil
    if @bracket_open == 0
      @pointer += 1
      if @pointer >= @arr.length # check for overflow
        # add new element to the end of the array
        @arr << 0
      end
    else
      # currently in a loop, so append to @loop
      @loop += ">"
    end
  end

  def + other
    # Increase the current cell, the pointer is pointing to.
    # Parms:
    # +other+:: isn't used, can be nil
    if @bracket_open == 0
      if @arr[@pointer] == 255 # check for overflow
        @arr[@pointer] = 0
      else
        @arr[@pointer] += 1
      end
    else
      # currently in a loop, so append to @loop
      @loop += "+"
    end
  end

  def - other
    # Decrease the current cell, the pointer is pointing to.
    # Parms:
    # +other+:: isn't used, can be nil
    if @bracket_open == 0
      if @arr[@pointer] == 0 # check for underflow
        @arr[@pointer] = 255
      else
        @arr[@pointer] -= 1
      end
    else
      # currently in a loop, so append to @loop
      @loop += "-"
    end
  end

  def dot other
    # Prints the char in th current cell.
    # Parms:
    # +other+:: isn't used, can be nil
    if @bracket_open == 0
      print @arr[@pointer].chr
    else
      # currently in a loop, so append to @loop
      @loop += "."
    end
  end

  def comma other
    # Reads a char from STDIN.
    # Parms:
    # +other+:: isn't used, can be nil
    if @bracket_open == 0
      @arr[@pointer] = STDIN.getch().ord
    else
      # currently in a loop, so append to @loop
      @loop += ","
    end
  end

  def brack_open other
    # Starts a loop.
    # Parms:
    # +other+:: isn't used, can be nil
    @bracket_open += 1
    if @bracket_open == 1
      @loop = "" # reset @loop
    else
      # currently in a loop, so append to @loop
      @loop += "["
    end
  end

  def brack_close other
    # Ends a loop.
    # Parms:
    # +other+:: isn't used, can be nil
    @bracket_open -= 1
    if @bracket_open == 0
      # execute code in @loop
      last = @loop
      @loop = ""
      while @arr[@pointer] != 0
        execute last
      end
    else
      # currently in a loop, so append to @loop
      @loop += "]"
    end
  end
end


# usage:

bi = BrainfuckInterpreter.new
if ARGV.length >= 1
  # if arguments are passed, they are used as code
  bi.execute ARGV.join("")
else
  # read code from stdin
  bi.execute gets()
end
