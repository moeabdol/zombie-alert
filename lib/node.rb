class Node
  attr_accessor :state, :parent, :children, :turn, :depth

  def initialize(args={})
    @state = args.fetch(:state, nil)
    @parent = args.fetch(:parent, nil)
    @children = args.fetch(:children, [])
    @turn = args.fetch(:turn, :zombies)
    @depth = args.fetch(:depth, 0)
  end

  def generate_children
    states = state.generate_substates(turn)
    states.each do |state|
      children << Node.new(state: state,
                           parent: self,
                           turn: turn == :zombies ? :humans : :zombies,
                           depth: depth + 1)

    end
  end
end
