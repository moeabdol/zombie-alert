require "forwardable"

class State
  extend Forwardable
  def_delegators :@state, :each, :[], :[]=
  include Enumerable

  attr_accessor :rows, :cols, :humans, :zombies

  def initialize(args={})
    @rows = args.fetch(:rows, 5)
    @cols = args.fetch(:cols, 5)
    @humans = args.fetch(:humans, [])
    @zombies = args.fetch(:zombies, [])
    validate_arguments
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
end
