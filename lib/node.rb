class Node
  attr_accessor :state, :parent, :children, :turn, :depth, :value

  def initialize(args={})
    @state = args.fetch(:state, nil)
    @parent = args.fetch(:parent, nil)
    @children = args.fetch(:children, [])
    @turn = args.fetch(:turn, :zombies)
    @depth = args.fetch(:depth, 0)
    @value = args.fetch(:value, nil)
  end

  def generate_children
    if turn == :zombies
      states = state.generate_human_substates
    elsif turn == :humans
      states = state.generate_zombie_substates
    end
    states.each do |state|
      children << Node.new(state: state,
                           parent: self,
                           turn: turn == :zombies ? :humans : :zombies,
                           depth: depth + 1)

    end
  end

  def evaluate
    @value = state.compute_euclidean_distances + state.humans.count
  end
end
