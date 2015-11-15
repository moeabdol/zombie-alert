require_relative "../../lib/state"
require_relative "../../lib/node"
require_relative "../../lib/tree"

describe Tree do
  context "node propagation" do
    it "does not propagate nodes if no humans present" do
      state = State.new(zombies: [[1, 1], [2, 2]])
      node = Node.new(state: state)
      tree = Tree.new(root: node)
      tree.send(:propagate, tree.root, 3)
      expect(tree.node_count).to eq(1)
      expect(tree.root.children).to be_empty
    end

    it "does not propagate nodes if no zombies present" do
      state = State.new(humans: [[1, 1], [2, 2]])
      node = Node.new(state: state)
      tree = Tree.new(root: node)
      tree.send(:propagate, tree.root, 3)
      expect(tree.node_count).to eq(1)
      expect(tree.root.children).to be_empty
    end

    it "propagates nodes to correct depth" do
      state = State.new(humans: [[0, 0], [0, 1]], zombies: [[4, 3], [4, 4]])
      node = Node.new(state: state)
      tree = Tree.new(root: node)
      tree.send(:propagate, tree.root, 3)
      expect(tree.node_count).not_to eq(1)
      expect(tree.root.children).not_to be_empty
      expect(tree.root.children[0].depth).to eq(1)
      expect(tree.root.children[0].children[0].depth).to eq(2)
      expect(tree.root.children[0].children[0].children[0].depth).to eq(3)
      expect(tree.root.children[0].children[0].children[0].children).to be_empty
    end
  end
end
