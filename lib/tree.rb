class Tree
  attr_accessor :root

  def initialize(args={})
    @root = args.fetch(:root, Node.new)
    propagate(root)
  end

  def propagate(node)
    node.state.draw
    puts "turn: #{node.turn}"
    puts "human count: #{node.state.humans.count}"
    puts "zombie count: #{node.state.zombies.count}"
    puts
    if !node.state.humans.count.zero?
      node.generate_children
      node.children.each do |child|
        propagate(child)
      end
    end
  end
end
