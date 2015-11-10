require_relative "lib/state"
require_relative "lib/node"
require_relative "lib/tree"

state = State.new(rows: 15,
                  cols: 30,
                  humans: [[0, 0], [0, 1], [1, 0], [1, 1], [4, 4]],
                  zombies: [[14, 9], [14, 8], [14, 11], [14, 13], [14, 14]])
node = Node.new(state: state)
Tree.new(root: node)
