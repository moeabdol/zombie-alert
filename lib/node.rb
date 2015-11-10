class Node
  attr_accessor :state, :parent, :children, :turn

  def initialize(args={})
    @state = args.fetch(:state, nil)
    @parent = args.fetch(:parent, nil)
    @children = args.fetch(:children, nil)
    @turn = args.fetch(:turn, :zombies)
  end

  def generate_children
    if turn == :zombies
      states = state.generate_substates(:humans)
    elsif turn == :humans
      states = state.generate_substates(:zombies)
    end
  end
end
