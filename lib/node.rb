class Node
  attr_accessor :state, :parent, :children, :turn

  def initialize(args={})
    @state = args.fetch(:state, nil)
    @parent = args.fetch(:parent, nil)
    @children = args.fetch(:children, [])
    @turn = args.fetch(:turn, :zombies)
  end

  def generate_children
    states = state.generate_substates(turn)
    states.each do |state|
      children << Node.new(state: state,
                           parent: self,
                           turn: turn == :zombies ? :humans : :zombies)

    end
  end
end
