require_relative "lib/state"
require_relative "lib/node"
require_relative "lib/tree"

state = State.new(rows: 15,
                  cols: 30,
                  humans: [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4]],
                  zombies: [[14, 0], [14, 1], [14, 2], [14, 3], [14, 4]])

node = Node.new(state: state)
Tree.new(root: node)
