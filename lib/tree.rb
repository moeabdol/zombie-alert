class Tree
  attr_accessor :root, :node_count

  def initialize(args={})
    @root = args.fetch(:root, Node.new)
    @node_count = args.fetch(:node_count, 1)
    solve(root)
    draw(root)
  end

  def solve(node, iterative_depth=5)
    if !node.state.humans.count.zero? && !node.state.zombies.count.zero?
      solution_found = false
      while !solution_found do
        puts "tree node count: #{node_count}"
        puts "tree depth #{node.depth}"
        puts "human count #{node.state.humans.count}"
        puts "zombie count #{node.state.zombies.count}"
        propagate(node, node.depth + iterative_depth)
        minmax(node)
        solution_found, node = walk_tree(node)
      end
      draw(node)
    else
      node.solution = true
    end
  end

  def draw(node)
    system "clear"
    node.state.draw
    puts "tree node count: #{node_count}"
    puts "turn: #{node.turn}"
    puts "step: #{node.depth}"
    puts "human count: #{node.state.humans.count}"
    puts "zombie count: #{node.state.zombies.count}"
    puts
    sleep(0.05)
    node.children.each do |child|
      if child.solution
        draw(child)
      end
    end
  end

  private

  def propagate(node, depth)
    if !node.state.humans.count.zero? && !node.state.zombies.count.zero?
      if node.depth < depth
        node.generate_children
        @node_count += node.children.count
        node.children.each do |child|
          propagate(child, depth)
        end
      end
    end
  end

  def minmax(node)
    if node.children.any?
      node.children.each do |child|
        minmax(child)
      end
      scores = []
      node.children.each { |child| scores << child.score }
      if node.turn == :zombies
        node.score = scores.max
      elsif node.turn == :humans
        node.score = scores.min
      end
    else
      node.evaluate
    end
  end

  def walk_tree(node)
    node.solution = true
    # draw(node)
    if node.children.any?
      node.children.each do |child|
        if node.score == child.score
          child.solution = true
          if child.state.humans.count.zero?
            return true, child
          end
          return walk_tree(child)
        end
      end
    else
      return false, node
    end
  end
end
