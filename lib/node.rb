class Node
  attr_accessor :state, :parent, :children, :turn, :depth, :score, :solution

  def initialize(args={})
    @state = args.fetch(:state, nil)
    @parent = args.fetch(:parent, nil)
    @children = args.fetch(:children, [])
    @turn = args.fetch(:turn, :humans)
    @depth = args.fetch(:depth, 0)
    @score = args.fetch(:score, nil)
    @solution = args.fetch(:solution, false)
  end

  def generate_children
    if turn == :zombies
      states = state.generate_human_substates
    elsif turn == :humans
      states = state.generate_zombie_substates
    end
    states.each do |state|
      children << Node.new(state: state, parent: self, depth: depth + 1,
                           turn: turn == :zombies ? :humans : :zombies)
    end
  end

  def evaluate
    # @score = state.compute_euclidean_distances
    @score = state.compute_manhattan_distances
  end
end
