require_relative "lib/state"
require_relative "lib/node"
require_relative "lib/tree"

state = State.new(rows: 6,
                  cols: 6,
                  humans: [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4]],
                  zombies: [[5, 0], [0, 5]])
node = Node.new(state: state)
tree = Tree.new(root: node)
