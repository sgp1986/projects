require 'pry'

class Button
  attr_accessor :pressed

  def initialize
    @pressed = false
  end

  def press
    @pressed = true
  end

  def release
    @pressed = false
  end
end

class Joystick
  attr_accessor :pushed

  def initialize
    @pushed = false
  end

  def push(direction)
    @pushed = true
  end

  def release
    @pushed = false
  end
end

class Controller
  attr_accessor :a_button, :b_button, :x_button, :y_button, :left_joystick, :right_joystick

  def initialize
    @a_button = Button.new
    @b_button = Button.new
    @x_button = Button.new
    @y_button = Button.new
    @left_joystick = Joystick.new
    @right_joystick = Joystick.new
  end

  def press_button(button, action_string)
    press_correct_button(button)
    puts action_string
    release_correct_button(button)
  end

  def hold_button(button, action_string)
    press_correct_button(button)
    puts action_string
  end

  def push_joystick(joystick, direction, action_string)
    joystick = @left_joystick
    joystick.push(direction)
    puts action_string
  end

  private

  def press_correct_button(button)
    case button
    when 'a button'
      @a_button.press
    end
  end

  def release_correct_button(button)
    case button
    when 'a button'
      @a_button.release
    end
  end
end

class GameEngine
  def initialize
    @player = Controller.new
    @state = {
      @moving => false,
      @sprinting => false,
      @stance => 'standing'
    }
  end

  def to_s
    @state
  end

  def game_start
    p @player
    prompt 'Welcome to the game!'
    prompt 'What do you want to do first?'
    puts '(press a button or move a joystick)'
    first_move = gets.chomp
    first_move = parse_input(first_move)
      p first_move
    do_move(first_move)
  end

  def do_move(move)
    # binding.pry
    if move.size == 2
      move.each do |m|
        # binding.pry
        if m[2] == 'joystick'
          # binding.pry
          @player.push_joystick(m[1], m.last, "You start to move #{m.last}.")
          @moving = true
          p @player
        elsif m[2] == 'button'
          # binding.pry
          button = m[1] + m[2]
          if m[0] == 'hold'
            @player.hold_button(button, 'You are now sprinting.')
            @sprinting = true
            p @player
          elsif m[0] == 'press'
            @player.press_button(button, 'You hurried for a second.')
            @sprinting = false
            p @player
          end
        end
      end
    else
      # binding.pry
      if move[2] == 'joystick'
        # binding.pry
        @player.push_joystick(move[1], move.last, "You start to move #{move.last}.")
        @moving = true
        p @player
      elsif move[2] == 'button'
        # binding.pry
        button = move[1] + move[2]
        if move[0] == 'hold'
          @player.hold_button(button, 'You are now sprinting.')
          @sprinting = true
          p @player
        elsif move[0] == 'press'
          @player.press_button(button, 'You hurried for a second.')
          @sprinting = false
          p @player
        end
      end
    end
  end

  def release(controller_input)
  end

  private

  def prompt(input)
    puts ">> " + input
  end

  def parse_input(move)
    if move.split.size > 4
      move = move.split('and').map(&:split)
    else
      move = move.split(' ')
    end

    move
  end
end

=begin
first word of input has 4 options
  press, push, hold, release
press and hold refer to buttons
push refers to joysticks
release refers to all of them

input = action [0], button or joystick name [1], button or joystick [2], direction if pushing joystick [3]
parse_input
  see if input has either button or joystick
    if neither, redo input
  if button
    see if pressing and releasing or holding
      if push
        run the press _ button method
      if hold
        run the hold _ button method
      if release
        run the release _ button method
  if joystick
    see if pushing or releasing
      if push
        run the push _ joystick method
      if release
        run the release _joystick method
state
  need to save the state of these categories
    moving (t/f or direction?)
    sprinting
    stand/crouch/prone
=end
    

game = GameEngine.new
game.game_start