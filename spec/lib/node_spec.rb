require_relative "../../lib/node"
require_relative "../../lib/state"

describe Node do
  context "children generation" do
    let(:state) { State.new(humans: [[0, 0], [2, 2], [4, 4]],
                            zombies: [[0, 4], [4, 0]])}

    it "generates child nodes with states where humans move" do
      node = Node.new(state: state, turn: :zombies)
      node.generate_children
      expect(node.children[0].state.zombies).to \
        match([[0, 4], [4, 0]])
      expect(node.children[0].state.humans).not_to \
        match([[0, 0], [2, 2], [4, 4]])
      expect(node.children.count).to eq(1)
    end

    it "generates child nodes with states where zombies move" do
      node = Node.new(state: state, turn: :humans)
      node.generate_children
      expect(node.children[0].state.humans).to \
        match([[0, 0], [2, 2], [4, 4]])
      expect(node.children[0].state.humans).not_to \
        match([[0, 4], [4, 0]])
      expect(node.children.count).to eq(1)
    end
  end
end
