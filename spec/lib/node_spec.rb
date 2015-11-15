require_relative "../../lib/node"
require_relative "../../lib/state"

describe Node do
  context "children generation" do
    let(:state) { State.new(humans: [[0, 0], [4, 4]],
                            zombies: [[0, 4], [4, 0]])}

    it "generates child nodes with states where humans move" do
      node = Node.new(state: state, turn: :zombies)
      node.generate_children
      expect(node.children.count).to eq(2)
      expect(node.children[0].state.zombies).to \
        match([[0, 4], [4, 0]])
      expect(node.children[1].state.zombies).to \
        match([[0, 4], [4, 0]])
      expect(node.children[0].state.humans).not_to \
        match([[0, 0], [4, 4]])
      expect(node.children[1].state.humans).not_to \
        match([[0, 0], [4, 4]])
      expect(node.children[0].state.humans).not_to \
        match(node.children[1].state.humans)
      expect(node.children[0].state).not_to \
        match(node.children[1].state)
    end

    it "generates child nodes with states where zombies move" do
      node = Node.new(state: state, turn: :humans)
      node.generate_children
      expect(node.children.count).to eq(2)
      expect(node.children[0].state.humans).to \
        match([[0, 0], [4, 4]])
      expect(node.children[1].state.humans).to \
        match([[0, 0], [4, 4]])
      expect(node.children[0].state.humans).not_to \
        match([[0, 4], [4, 0]])
      expect(node.children[1].state.humans).not_to \
        match([[0, 4], [4, 0]])
      expect(node.children[0].state.zombies).not_to \
        match(node.children[1].state.zombies)
      expect(node.children[0].state).not_to \
        match(node.children[1].state)
    end
  end

  it "evaluates node value correctly" do
    state = State.new(humans:[[1, 1], [1, 2]], zombies: [[4, 2], [4, 3]])
    node = Node.new(state: state)
    node.evaluate
    expect(node.value).to eq(15)
    state = State.new(zombies: [[4, 2], [4, 3]])
    node = Node.new(state: state)
    node.evaluate
    expect(node.value).to eq(0)
  end
end
