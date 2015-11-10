require "forwardable"

class State
  extend Forwardable
  def_delegators :@state, :each, :[], :[]=
  include Enumerable

  attr_accessor :state, :rows, :cols, :humans, :zombies

  def initialize(args={})
    @rows = args.fetch(:rows, 5)
    @cols = args.fetch(:cols, 5)
    @humans = args.fetch(:humans, [])
    @zombies = args.fetch(:zombies, [])
    validate_arguments
    convert_humans_to_zombies
    construct_state
  end

  def draw
    draw_top_border
    rows.times do |r|
      print "#"
      cols.times do |c|
        if humans.include?([r, c])
          print "H"
        elsif zombies.include?([r, c])
          print "Z"
        else
          print " "
        end
      end
      puts "#"
    end
    draw_bottom_border
  end

  def generate_substates(turn)
    moves = move_team(turn)
    if turn == :humans
      substates = [State.new(rows: rows, cols: cols, humans: humans,
                             zombies: moves)]
    elsif turn == :zombies
      substates = [State.new(rows: rows, cols: cols, humans: moves,
                             zombies: zombies)]
    end
  end

  private

  def validate_arguments
    if rows <= 0 || cols <= 0
      raise "InvalidRowsOrColumns"
    elsif is_humans_or_zombies_out_of_range?
      raise "HumansOrZombiesOutOfRange"
    elsif is_humans_and_zombies_overlapping?
      raise "OverlappingHumansAndZombies"
    end
  end

  def is_humans_or_zombies_out_of_range?
    (humans + zombies).each do |p|
      return true if p[0] < 0 || p[0] >= rows || p[1] < 0 || p[1] >= cols
    end
    return false
  end

  def is_humans_and_zombies_overlapping?
    humans.each do |h|
      return true if zombies.include?(h)
    end
    return false
  end

  def convert_humans_to_zombies
    zombies.each do |zombie|
      if zombie[0] > 0 && humans.include?([zombie[0] - 1, zombie[1]])
        zombies << humans.delete([zombie[0] - 1, zombie[1]])
      end
      if zombie[0] < rows - 1 &&  humans.include?([zombie[0] + 1, zombie[1]])
        zombies << humans.delete([zombie[0] + 1, zombie[1]])
      end
      if zombie[1] < cols - 1 &&  humans.include?([zombie[0], zombie[1] + 1])
        zombies << humans.delete([zombie[0], zombie[1] + 1])
      end
      if zombie[1] > 0 &&  humans.include?([zombie[0], zombie[1] - 1])
        zombies << humans.delete([zombie[0], zombie[1] - 1])
      end
    end
  end

  def construct_state
    @state = Array.new(rows){ Array.new(cols) }
    rows.times do |r|
      cols.times do |c|
        if humans.include?([r, c])
          @state[r][c] = "H"
        elsif zombies.include?([r, c])
          @state[r][c] = "Z"
        else
          @state[r][c] = nil
        end
      end
    end
  end

  def draw_top_bottom_border
    0.upto(cols) { print "#" }
    puts "#"
  end

  alias_method :draw_top_border, :draw_top_bottom_border
  alias_method :draw_bottom_border, :draw_top_bottom_border

  def move_team(turn)
    team = clone_team(turn)
    moves = []
    team.shuffle.each do |member|
      directions.shuffle.each do |direction|
        if can_move?(member, direction, moves)
          moves << move_member(member, direction)
          break
        end
      end
    end
  end

  def clone_team(turn)
    if turn == :humans
      zombies.clone
    elsif turn == :zombies
      humans.clone
    end
  end

  def directions
    [:up, :down, :right, :left]
  end

  def can_move?(member, direction, moves)
    if direction == :up && member[0] > 0 &&
        state[member[0] - 1][member[1]].nil? &&
          !moves.include?([member[0] - 1, member[1]])
      return true
    elsif direction == :down && member[0] < rows - 1 &&
            state[member[0] + 1][member[1]].nil? &&
              !moves.include?([member[0] + 1, member[1]])
      return true
    elsif direction == :right && member[1] < cols - 1 &&
            state[member[0]][member[1] + 1].nil? &&
              !moves.include?([member[0], member[1] + 1])
      return true
    elsif direction == :left && member[1] > 0 &&
            state[member[0]][member[1] - 1].nil? &&
              !moves.include?([member[0], member[1] - 1])
      return true
    else
      return false
    end
  end

  def move_member(member, direction)
    if direction == :up
      member[0] -= 1
    elsif direction == :down
      member[0] += 1
    elsif direction == :right
      member[1] += 1
    elsif direction == :left
      member[1] -= 1
    end
  end
end
