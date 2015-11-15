class Tree
  attr_accessor :root, :node_count

  def initialize(args={})
    @root = args.fetch(:root, Node.new)
    @node_count = args.fetch(:node_count, 1)
    solve(root)
    # draw(root)
  end

  def solve(node, iterative_depth=3)
    if !node.state.humans.count.zero? && !node.state.zombies.count.zero?
      solution_found = false
      while solution_found == false do
        propagate(node, node.depth + iterative_depth)
        solution_found, node = minmax(node)
      end
    else
      node.solution = true
    end
  end

  def draw(node)
    system "clear"
    node.state.draw
    puts "turn: #{node.turn}"
    puts "step: #{node.depth}"
    puts "human count: #{node.state.humans.count}"
    puts "zombie count: #{node.state.zombies.count}"
    puts
    sleep(0.05)
    node.children.each do |child|
      draw(child)
    end
  end

  private

  def propagate(node, depth)
    if !node.state.humans.count.zero? && !node.state.zombies.count.zero?
      if node.depth == 0 || node.depth % depth != 0
        node.generate_children
        @node_count += node.children.count
        node.children.each do |child|
          propagate(child, depth)
        end
      end
    end
  end

  def minmax(node)
  end
end
